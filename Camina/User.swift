//
//  File.swift
//  EastCoastTrail
//
//  Created by Diego Zuluaga on 2017-07-04.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import Foundation
import CoreData

@objc(defaultUser)
public class defaultUser :NSManagedObject {
    
}

extension defaultUser {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<defaultUser> {
        return NSFetchRequest<defaultUser>(entityName: "defaultUser")
    }
    
    @NSManaged public var ID: String?
    @NSManaged public var name: String?

    @NSManaged public var gender: String?
    @NSManaged public var age: String?
    @NSManaged public var profilePicURL: String?
    @NSManaged public var totalSteps : String?
    @NSManaged public var trailsFinished : NSArray?
    @NSManaged public var totalDistance : String?
    @NSManaged public var sessions : NSMutableOrderedSet?
    
}


// MARK: Generated accessors for session
extension defaultUser {
    
    @objc(insertObject:inSessionAtIndex:)
    @NSManaged public func insertIntoSession(_ value: Session, at idx: Int)
    
    @objc(removeObjectFromSessionAtIndex:)
    @NSManaged public func removeFromSession(at idx: Int)
    
    @objc(insertSession:atIndexes:)
    @NSManaged public func insertIntoSession(_ values: [Session], at indexes: NSIndexSet)
    
    @objc(removeSessionAtIndexes:)
    @NSManaged public func removeFromSession(at indexes: NSIndexSet)
    
    @objc(replaceObjectInSessionAtIndex:withObject:)
    @NSManaged public func replaceSession(at idx: Int, with value: Session)
    
    @objc(replaceSessionAtIndexes:withSession:)
    @NSManaged public func replaceSession(at indexes: NSIndexSet, with values: [Session])
    
    @objc(addSessionObject:)
    @NSManaged public func addToBitDay(_ value: Session)
    
    @objc(removeSessionObject:)
    @NSManaged public func removeFromBitDay(_ value: Session)
    
    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSOrderedSet)
    
    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSOrderedSet)
    
}
