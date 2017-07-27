//
//  mainViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CoreLocation
import AVFoundation
import CoreMotion
import CoreData



class mainViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {

    

    let navView : UIView = {
        let view = UIView()
        // Create the label
        let label = UILabel()
        label.text = "Camina"
        label.sizeToFit()
        label.center = view.center
        label.textAlignment = NSTextAlignment.center
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "trail_sign_fill")
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect-4, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(label)
        view.addSubview(image)
        return view
    }()
    
    let cellId = "cellId"
    let locationManager = CLLocationManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    var trailHeads = [Head]()
    var filterTrailHeads = [Head]()
    
    var placemarks = [Placemark]()
    var tempPlacemarks = [Placemark]()
    var activePlacemarks = [CLRegion]()
    var activeTrailheads = [CLRegion]()
    var allPlacemarks = [CLRegion]()
    var allLocations = [CLLocation]()
    
    var shortestDistance : Double!
    var locationName : String!
    
    //vars used for the notification system
    var readText = ""
    var lastIndex = -2
    var lastID = ""
    var activeSession = false
    
    
       
    var closestID : String?
    var closestLocation: CLLocation?
    
        
    var tempArray : [Session] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if Auth.auth().currentUser == nil{
        //            perform(#selector(presentRootView), with: nil, afterDelay: 0)
        //        }
        
  
        tableView.register(trailHeadsCell.self, forCellReuseIdentifier: cellId)
        print(currentReachabilityStatus)
        
        fetchTrailHead()
        fetchPlacemarks()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setupSearchView()
        setupNavBarItem()
        //for location in locationManager.monitoredRegions {
            //locationManager.stopMonitoring(for: location)
            //print(location)
        //}
    }
    
    


    
    //function to make sure that the location services are always allowed
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. please enable locatiom services for this app in privacy settings")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupNavBarItem(){
        // Add both the label and image view to the navView
        
        self.navigationItem.titleView = navView
        navView.sizeToFit()
        
    }
    
    


    func fetchTrailHead(){
        if let path = Bundle.main.path(forResource: "head", ofType: "geojson") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let trailHeadArray = jsonDictionary?["features"] as? [[String: AnyObject]] {
                    for trailheadDictionary in trailHeadArray {
                        let trailhead = Head()
                        trailhead.setValuesForKeys(trailheadDictionary)
                        self.trailHeads.append(trailhead)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let err {
                print(err)
            }
        }
    }
    
    func fetchPlacemarks() {
        if let path = Bundle.main.path(forResource: "point", ofType: "geojson") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let placemarkArray = jsonDictionary?["features"] as? [[String: AnyObject]] {
                    for placemarkDictionary in placemarkArray {

                        let placemark = Placemark()
                        placemark.setValuesForKeys(placemarkDictionary)
                        self.placemarks.append(placemark)
                     
                    }
                }
            } catch let err {
                print(err)
            }
        }
    }
    




    
    //MARK: - Table functions
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterTrailHeads.count
        }
        return trailHeads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! trailHeadsCell
        let trailHead: Head
        if searchController.isActive && searchController.searchBar.text != "" {
            trailHead = filterTrailHeads[indexPath.row]
        }else{
            trailHead  = trailHeads[indexPath.row]
        }
        
        
        cell.trail = trailHead
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let infoView = infoController(collectionViewLayout: layout)
        self.hidesBottomBarWhenPushed = true;
        infoView.trailProperties = trailHeads[indexPath.row].properties
        infoView.trailLandMark = placemarks
        self.navigationController?.pushViewController(infoView, animated: true)
        self.hidesBottomBarWhenPushed = false;
        
   }
    

    // function to retrieve the data from core data
    func getData() {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()

        //3
        do {
            tempArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }

    
   

}













