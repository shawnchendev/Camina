//
//  Review.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-01.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation

import Foundation

class Review: NSObject{
    //    var uid : String?
    var title : String?
    var review : String?
    var trailID : String?
    var userID : String?
    var rating : Int?
    
    init(dictionary: [String: AnyObject]) {
        self.title = dictionary["title"] as? String
        self.review = dictionary["review"] as? String
        self.trailID = dictionary["trailID"] as? String
        self.userID = dictionary["UserID"] as? String
        self.rating = dictionary["rating"] as? Int
    }
    
}
