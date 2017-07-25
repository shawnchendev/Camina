//
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-12.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation


class Head: SafeJsonObject{
    var properties : Properties?
    var geometry: Geometry?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "properties" {
            properties = Properties()
            properties?.setValuesForKeys(value as! [String: AnyObject])
        }
        if key == "geometry" {
            geometry = Geometry()
            geometry?.setValuesForKeys(value as! [String: AnyObject])
        }

    }
}

class Properties: NSObject{
    var OBJECTID:NSNumber?
    var ParkID: String?
    var Name: String?
    var Distance: NSNumber?
    var Accessibil: NSNumber?
    var Stroll: NSNumber?
    var Brisk: NSNumber?
    var `Type`: String?
    var URL: String?
    var CAPTION: String?
    var Lat: NSNumber?
    var Long: NSNumber?
    var Bicycle: NSNumber?
    var Construct: NSNumber?
    var Fitness: NSNumber?
    var Heritage: NSNumber?
    var Nature: NSNumber?
    var ParkSpace: NSNumber?
    var Scenic: NSNumber?
    var Coastal: NSNumber?
    var Parking: String?
    var Sidewalk: NSNumber?
    var Municipali: String?
    var Winter: NSNumber?
    var Exit: NSArray?
}


class Geometry: NSObject{
    var type:String?
    var coordinates:NSArray?
    
}



