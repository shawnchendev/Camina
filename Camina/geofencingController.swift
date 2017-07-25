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

extension mainViewController: CLLocationManagerDelegate {
    
    //starts monitoring for the trail heads
    func setupGeofencing(){
        if let path = Bundle.main.path(forResource: "trails", ofType: "geojson") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let trailHeadArray = jsonDictionary?["features"] as? [[String: AnyObject]] {
                    for trailheadDictionary in trailHeadArray {
                        let trailhead = TrailCoords()
                        trailhead.setValuesForKeys(trailheadDictionary)
                        setupRegions(trail: (trailhead.geometry?.coordinates)!, name: (trailhead.properties?.ParkID)!)
                        
                    }
                }
            } catch let err {
                
                print(err)
            }
        }
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
                shortestDistance = location!.distance(from: aLocation)
                locationName = allPlacemarks[allLocations.index(of: aLocation)!].identifier
                closestLocation = aLocation
                if shortestDistance < 10 {
                    let head = getHead(name: locationName)
                    if head.properties?.Name != nil && !activeSession {
                        setupSession(head: head)
                        setupTrailHeadNotification(head: head)
                        setupActivePlacemarks(head: head)
                        //print(head.properties?.Name)
                    }
                    
                    
                }
            }
        }
        
    }
    
    // expands all of the placemarks of a given trail head
    func setupActivePlacemarks( head:Head){
        print("here")
        for placemark in placemarks {
            if placemark.properties?.ParkID == head.properties?.ParkID {
                tempPlacemarks.append(placemark)
            }
        }
        for activePlacemark in tempPlacemarks {
            let coordinate = CLLocationCoordinate2D(latitude: (activePlacemark.geometry?.coordinates![1])! as! CLLocationDegrees, longitude: (activePlacemark.geometry?.coordinates![0])! as! CLLocationDegrees)
            let region = CLCircularRegion(center: coordinate, radius: 50, identifier: (activePlacemark.properties?.NAME)!)
            locationManager.startMonitoring(for: region)
            activePlacemarks.append(region)
            print(region.identifier)
        }
        
//        let coordinate = CLLocationCoordinate2D(latitude: head.properties?.Exit![1] as! CLLocationDegrees, longitude: head.properties?.Exit![0] as! CLLocationDegrees)
//        let region = CLCircularRegion(center: coordinate, radius: 50, identifier: "exit")
//        locationManager.startMonitoring(for: region)
//        activePlacemarks.append(region)
        
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
        print("enter placemark")
        if region.identifier == "exit"{
            return
        }
//        var isHead = false
//        var trailHead = Head()
//        //decide wheter or not is a placemark or head
//        for i in 0...trailHeads.count-1 {
//            if region.identifier == trailHeads[i].properties?.Name!{
//                trailHead = trailHeads[i]
//                isHead = true
//            }
//        }
        
//        //if a trail, is it the beginning of a session?
//        if isHead {
//            if region.identifier != lastID {
//                //check if its already in an active session
//                if !activeSession {
//                    if(CMPedometer.isStepCountingAvailable()){
//                        print("session started")
//                        setupSession(head: trailHead)
//                    }
//                }
//                lastID = region.identifier
//                
//                setupActivePlacemarks(head: trailHead)
//                setupTrailHeadNotification(head: trailHead)
//                
//            }
//        } else {
            var placemark = Placemark()
            for i in 0...placemarks.count-1 {
                if region.identifier == placemarks[i].properties?.NAME!{
                    placemark = placemarks[i]
                }
            }
            if region.identifier != lastID {
                lastID = region.identifier
                pastCheckPoint = region.identifier
                setupPlacemarkNotification(placemark: placemark)
            }
        //}
        
    }
    
    //function that triggers whenever the user exits a monitored area, range is roughly twice of the radius length of the area
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if (region.identifier == "exit") && activeSession {
            finishSession()
            //stop monitoring the placemarks
            stopActivePlacemarks()
        }
        
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
        let newDistance = userLocation!.distance(from: closestLocation!)
        if newDistance > shortestDistance {
            checkProximity()
          
        }
        
        if shortestDistance > 50 && activeSession {
            finishSession()
            stopActivePlacemarks()
        }
        
        if activeSession {
            print(time)
        }
       
     
    }
}
