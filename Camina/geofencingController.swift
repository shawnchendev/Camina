//
//  geofencingController.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-19.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import CoreLocation
import UserNotifications
import CoreMotion
import UIKit
import Firebase

extension mapViewController: CLLocationManagerDelegate {


    func getHead ( name: String) -> Head {
        for aHead in trailHeads {
            if aHead.properties?.ParkID == name {
                return aHead
            }
        }
        return Head()
    }

    //starts monitoring for the trail heads
    func setupGeofencing(){
        //DispatchQueue.global(qos: .background).async(execute: {
            
            let refh = FIRDatabase.database().reference()
            let trailRef = refh.child("Trails")
            
            trailRef.observeSingleEvent(of: .value, with: { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    for trailPath in dictionary {
                        //let path = trailPath.value["value"]
                        do {
                            let head = trailPath.value["Path"] as! [String : Any]
                            let path = head["Information"] as! [String: Any]
                            let trailhead = TrailCoords()
                            trailhead.setValuesForKeys(path)
                            self.setupRegions(trail: (trailhead.geometry?.coordinates)!, name: (trailhead.properties?.ParkID)!)

                            

                        }catch let err{
                            print("Trail head parsing failed")
                            print(err)
                        }
                        
                    }
                }
                
            })
        //})
    }

    //sets all the points in the trail paths for proximity check
    func setupRegions( trail: NSArray, name: String){
        for i in 0...trail.count-1{
            let line : NSArray = trail[i] as! NSArray
            for j in 0...line.count-1{
                let point: NSArray = line[j] as! NSArray
                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:point[1] as! CLLocationDegrees,longitude:point[0] as! CLLocationDegrees ), radius: 100, identifier: name)
                allPlacemarks.append(region)
                
                let location = CLLocation(latitude: point[1] as! CLLocationDegrees, longitude: point[0] as! CLLocationDegrees)
                allLocations.append(location)
            }
            
            
        }
        if locationManager.location != nil {
            checkProximity()
        }
        
    }

    //check which trail paths are closer to the user
    func checkProximity(){
        shortestDistance = 9999999
        let location = locationManager.location
        for aLocation in allLocations {
            if location!.distance(from: aLocation) < shortestDistance {
                let tempDistance = location!.distance(from: aLocation)
                if tempDistance < shortestDistance {
                    shortestDistance = tempDistance
                }
                locationName = allPlacemarks[allLocations.index(of: aLocation)!].identifier
                closestLocation = aLocation
            }
        }
        
        
        if shortestDistance < 100 {
            let head = getHead(name: locationName)
            if head.properties?.ParkID != nil && !activeSession {
                //setupSession(head: head)
                trailID = head.properties?.ParkID
                trailN = head.properties?.Name
                setupTrailHeadNotification(head: head)
                setupActivePlacemarks(head: head)
                //print(head.properties?.Name)
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Start session"), object: nil)
                startSession()
            }
            
            
        }

        
    }

    // expands all of the placemarks of a given trail head
    func setupActivePlacemarks( head:Head){
        for placemark in placemarks {
            if placemark.properties?.ParkID == head.properties?.ParkID {
                tempPlacemarks.append(placemark)
            }
        }
        for activePlacemark in tempPlacemarks { 
            let coordinate = CLLocationCoordinate2D(latitude: (activePlacemark.geometry?.coordinates![1])! as! CLLocationDegrees, longitude: (activePlacemark.geometry?.coordinates![0])! as! CLLocationDegrees)
            let region = CLCircularRegion(center: coordinate, radius: 30, identifier: (activePlacemark.properties?.NAME)!)
            locationManager.startMonitoring(for: region)
            activePlacemarks.append(region)
        }
        
    }

    //stops monitoring the active placemarks
    func stopActivePlacemarks(){
        for placemark in activePlacemarks {
            locationManager.stopMonitoring(for: placemark)
        }
        activePlacemarks = []
    }


       
    //function that triggers whenever the user enters a monitored area, monitored range is roughly the same as when the area is created
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        var placemark = Placemark()
        for i in 0...placemarks.count-1 {
            if region.identifier == placemarks[i].properties?.NAME!{
                placemark = placemarks[i]
            }
        }
        if region.identifier != lastID && placemark.properties?.NAME != nil{
            lastID = region.identifier
            pastCheckPoint = region.identifier
            let state = UIApplication.shared.applicationState
            if state == .background{
                let place = placemarkAlertView(placemarkName: (placemark.properties?.NAME)!, description: (placemark.properties?.caption)!)
                place.show(animated: true)
                setupPlacemarkNotification(placemark: placemark)
            } else if state == .active{
           
                let place = placemarkAlertView(placemarkName: (placemark.properties?.NAME)!, description: (placemark.properties?.caption)!)
                place.show(animated: true)
        }
        
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }

    //function that triggers whenever the user location changes to check proximity to existing areas
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locationManager.location

        if closestLocation == nil {
            checkProximity()
        }
        if activeSession {
            for loc in locations {
                allCoordinates.append(loc.coordinate)
            }
            //updateLocationLine()
        }
        let newDistance = userLocation!.distance(from: closestLocation!)
        if newDistance > shortestDistance {
            checkProximity()
        }
        if newDistance < 50 {
            checkProximity()
        }
        
        if shortestDistance > 100 && activeSession {
            stopSession()
            stopActivePlacemarks()
        }
       
     
    }


    }
