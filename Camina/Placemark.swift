//
//  Placemark.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-13.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import CoreLocation


class Placemark: SafeJsonObject{
    var properties : PlacemarkProperties?
    var geometry: Geometry?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "properties" {
            properties = PlacemarkProperties()
            properties?.setValuesForKeys(value as! [String: AnyObject])
        }
        if key == "geometry" {
            geometry = Geometry()
            geometry?.setValuesForKeys(value as! [String: AnyObject])
        }
    }
}

class PlacemarkProperties: NSObject{
    var OBJECTID:NSNumber?
    var FEATURE_ID:String?
    var TRAIL:String?
    var POINT_NAME:String?
    var FCODE:String?
    var YEAR_:NSNumber?
    var ParkID:String?
    var Link:String?
    var Maintenanc:String?
    var InspCode:NSNumber?
    var InspDesc:String?
    var InspDate:Date?
    var InspPhoto:NSNumber?
    var Installati:String?
    var Point_Numb:NSNumber?
    var NAME:String?

}


