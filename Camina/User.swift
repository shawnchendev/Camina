//
//  File.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-04.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation

class defaultUser: NSObject{
    var uid : String?
    var name : String?
    var email : String?
    var age : String?
    var gender : String?
    var profileImageURL : String?
    
    init(i: String, n: String, e: String, a: String, g: String, p: String) {
        uid = i
        name = n
        email = e
        age = a
        gender = g
        profileImageURL = p
    }
    
}
