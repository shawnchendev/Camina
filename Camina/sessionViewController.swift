//
//  sessionViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-07-21.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Mapbox

class sessionView: UIViewController, CLLocationManagerDelegate  {
    var mapView : MGLMapView!
    var trailProperties : Properties?
    
    let locationManager = CLLocationManager()
    
    
    let statsView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "3ACFD5")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trailName : UILabel = {
        let label = UILabel()
        label.text = "text"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let distance : UILabel = {
        let label = UILabel()
        label.text = "Distance: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let time : UILabel = {
        let label = UILabel()
        label.text = "Time: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let steps : UILabel = {
        let label = UILabel()
        label.text = "Total Steps: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    let travelDistance : UILabel = {
        let label = UILabel()
        label.text = "1000m"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let travelTime : UILabel = {
        let label = UILabel()
        label.text = "0:00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let totalSteps : UILabel = {
        let label = UILabel()
        label.text = "0 steps"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hex: "3ACFD5")
        
        locationManager.delegate = self
        
        //locationManager.startUpdatingLocation()
        
        //locationManager.startUpdatingHeading()
        
        view.backgroundColor = .white
        setupMapView()
        view.addSubview(statsView)
        setupStatView()
        view.addSubview(mapView)
        drawTrailPathLine()
    }
    
    
    func setupMapView(){
        let coordinate = CLLocationCoordinate2DMake(trailProperties?.Lat as! CLLocationDegrees, trailProperties?.Long as! CLLocationDegrees)
        let height  = view.frame.height - statsView.frame.height - 20
        mapView = MGLMapView(frame:CGRect(x: 0, y: 140, width: view.frame.width, height: height))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(coordinate, zoomLevel: 16, animated: false)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.maximumZoomLevel = 17
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupStatView(){
        statsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statsView.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
        statsView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        trailName.text = trailProperties?.Name
        
        statsView.addSubview(trailName)
        statsView.addSubview(distance)
        statsView.addSubview(travelDistance)
        statsView.addSubview(time)
        statsView.addSubview(travelTime)
        statsView.addSubview(steps)
        statsView.addSubview(totalSteps)
        
        trailName.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 8).isActive = true
        trailName.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 8).isActive = true
        trailName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        distance.topAnchor.constraint(equalTo: trailName.bottomAnchor, constant: 14).isActive = true
        distance.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        distance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        time.topAnchor.constraint(equalTo: distance.bottomAnchor, constant: 4).isActive = true
        time.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        time.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        steps.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 4).isActive = true
        steps.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        steps.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        travelDistance.leftAnchor.constraint(equalTo: steps.rightAnchor, constant: 20).isActive = true
        travelDistance.topAnchor.constraint(equalTo: trailName.bottomAnchor, constant: 14).isActive = true
        travelDistance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        travelTime.leftAnchor.constraint(equalTo: steps.rightAnchor, constant: 20).isActive = true
        travelTime.topAnchor.constraint(equalTo: travelDistance.bottomAnchor, constant: 4).isActive = true
        travelTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        totalSteps.leftAnchor.constraint(equalTo: steps.rightAnchor, constant: 20).isActive = true
        totalSteps.topAnchor.constraint(equalTo: travelTime.bottomAnchor, constant: 4).isActive = true
        totalSteps.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    
    
    func drawTrailPathLine() {
        // Parsing GeoJSON can be CPU intensive, do it on a background thread
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
            
            let jsonPath = Bundle.main.path(forResource: "trails", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            
            do {
                // Convert the file contents to a shape collection feature object
                let data = try Data(contentsOf: url)
                let shapeCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
                for i in 0...((shapeCollectionFeature.shapes.count) - 1){
                    if let polyline = shapeCollectionFeature.shapes[i] as? MGLPolylineFeature {
                        // Optionally set the title of the polyline, which can be used for:
                        //  - Callout view
                        //  - Object identification
                        if polyline.attributes["ParkID"] as? String != self.trailProperties?.ParkID {
                            continue
                        }
                        polyline.title = polyline.attributes["Name"] as? String
                        // Add the annotation on the main thread
                        DispatchQueue.main.async(execute: {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(polyline)
                        })
                    }else{
                        let multipolyline = shapeCollectionFeature.shapes[i] as? MGLMultiPolylineFeature
                        if multipolyline?.attributes["ParkID"] as? String != self.trailProperties?.ParkID {
                            continue
                        }
                        multipolyline?.title = multipolyline?.attributes["Name"] as? String
                        for i in 0...((multipolyline?.polylines.count)! - 1){
                            DispatchQueue.main.async(execute: {
                                // Unowned reference to self to prevent retain cycle
                                [unowned self] in
                                self.mapView.addAnnotation((multipolyline?.polylines[i])!)
                            })
                        }
                    }
                }
            }
            catch {
                print("GeoJSON parsing failed")
            }
        })
    }
    

    
    
    
    
    
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

