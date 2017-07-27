//
//  SafeJsonObject.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-07-05.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//
import CoreData

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}
