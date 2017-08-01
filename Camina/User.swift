//
//  File.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-04.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation

class defaultUser: NSObject{
//    var uid : String?
    var name : String?
    var email : String?
    var age : String?
    var gender : String?
    var profileImageURL : String?
    
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.age = dictionary["age"] as? String
        self.gender = dictionary["gender"] as? String
        self.profileImageURL = dictionary["profileImageUrl"] as? String
    }
    
}
