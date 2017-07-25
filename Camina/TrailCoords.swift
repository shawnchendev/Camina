//
//  trailCoords.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-18.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation


class TrailCoords: SafeJsonObject{
    var properties : CoordProperties?
    var geometry: Geometry?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "properties" {
            properties = CoordProperties()
            properties?.setValuesForKeys(value as! [String: AnyObject])
        }
   
        if key == "geometry" {
            geometry = Geometry()
            geometry?.setValuesForKeys(value as! [String: AnyObject])
        }
        
    }
}


class CoordProperties: NSObject{
    var ParkID: String?
    var Name: String?
    var Distance: NSNumber?
    var Stroll: NSNumber?
    var Brisk: NSNumber?
    var `Type`: String?
    var Difficulty: NSNumber?
    var Accessibil: NSNumber?
    var Cycling: NSNumber?
    var Rotation: NSNumber?
    var Completed: NSNumber?
    var Id : NSNumber?
    var Shape_Leng:NSNumber?
    var HB_ID: String?
    var Town: String?
    var Coastal: NSNumber?
    var Fitness : NSNumber?
    var Heritage : NSNumber?
    var Nature: NSNumber?
    var ParkSpace: NSNumber?
    var Scenic : NSNumber?
    var Sidewalk: NSNumber?
    var Winter: NSNumber?
    var Shape_Le_1 : NSNumber?
}
