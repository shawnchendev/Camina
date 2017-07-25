//
//  Session.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-04.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import CoreData

@objc(Session)
public class Session :NSManagedObject {
}

extension Session {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }
    @NSManaged public var time : String?
    @NSManaged public var date : Date?
    @NSManaged public var steps : NSNumber?
    @NSManaged public var distance: NSNumber?
    @NSManaged public var pastCheckPoint : String?
    @NSManaged public var trailID : String?
    //@NSManaged public var user : defaultUser?
    
}
