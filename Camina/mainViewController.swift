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
  
        tableView.register(trailHeadsCell.self, forCellReuseIdentifier: cellId)
        print(currentReachabilityStatus)
        fetchTrailHead()
        fetchPlacemarks()
        fetchReviewFromFirebase()
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        setupSearchView()
        setupNavBarItem()
        tableView.separatorColor = .white
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
                        trailHeads.append(trailhead)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
             
            } catch let err {
                print(err)
            }
        }
    }
    
    func fetchReviewFromFirebase() {
        for thead in trailHeads {
            var trating = 0
            var rateCount = 0
            let ref = Database.database().reference()
            ref.child("Review").observe(.value, with: { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for review in dictionary {
                        let reviewDict = review.value as! [String : AnyObject]
                        let review = Review(dictionary: reviewDict)
                        if review.trailID == thead.properties?.ParkID {
                            trating += review.rating!
                            rateCount += 1
                           
                        }
                    }
                    if (trating != 0 && rateCount != 0) {
                        thead.rating = Int(trating / rateCount)
                    }
                    else{
                        thead.rating = 0
                    }
                }
                

                
            })
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                
            })
        
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
                print(err.localizedDescription)
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
        if trailHead.rating == nil { trailHead.rating = 0}
        cell.starViews.rating = trailHead.rating!
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let layout = UICollectionViewFlowLayout()
//        let infoView = infoController(collectionViewLayout: layout)
        let trailDetailView = trailDetailViewController()
        self.hidesBottomBarWhenPushed = true;
        trailDetailView.trailHead = trailHeads[indexPath.row]
        var tp = [Placemark]()
        for p in placemarks{
            if trailHeads[indexPath.item].properties?.ParkID != p.properties?.ParkID{
                continue
            } else {
            tp.append(p)
            }
        }
        trailDetailView.trailPlacemark = tp
        self.navigationController?.pushViewController(trailDetailView, animated: true)
        self.hidesBottomBarWhenPushed = false;

   }
    



    
   

}













