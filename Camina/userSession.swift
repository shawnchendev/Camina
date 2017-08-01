//
//  userSession.swift
//  Camina
//
//  Created by Shawn Chen on 2017-08-01.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit

class userSession: NSObject {
    
    var uid : String?
    var date : String?
    var distance: Double?
    var lastCheckPoint: String?
    var time : Int?
    var trailId: String?
    var steps: Int?
    
    var path: [Any]
    
    init(dictionary: [String: AnyObject]) {
        self.uid = dictionary["UserID"] as? String
        self.date = dictionary["date"] as? String
        self.distance = dictionary["distance"] as? Double
        self.lastCheckPoint = dictionary["pastCheckpoint"] as? String
        self.steps = dictionary["steps"] as? Int
        self.time = dictionary["time"] as? Int
        self.trailId = dictionary["trailID"] as? String
        self.path = (dictionary["path"] as? [Any])!

    }
}


class userProfile: NSObject {
    var totalSteps: Int?
    var totalTime: Int?
    var totalSession: Int?
    var totalDistance: Double?
    
    init(step:Int,time:Int, session: Int, distance: Double) {
        totalSteps = step
        totalTime = time
        totalDistance = distance
        totalSession = session

    }
}
