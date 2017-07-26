//
//  fetchingController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-07-26.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation


extension mapViewController {
    
    
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
                        //                        let coordinate = CLLocationCoordinate2D(latitude: trailhead.properties?.Lat as! CLLocationDegrees, longitude: trailhead.properties?.Long as! CLLocationDegrees)
                        //                        let region = CLCircularRegion(center: coordinate, radius: 50, identifier: (trailhead.properties?.Name)!)
                        //                        locationManager.startMonitoring(for: region)
                        //                        activeTrailheads.append(region)
                    }
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
    

}
