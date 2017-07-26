//
//  Session+CoreDataProperties.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-07-25.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import CoreData
import MapKit


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var time: String?
    @NSManaged public var date: Date?
    @NSManaged public var steps: NSNumber?
    @NSManaged public var distance: NSNumber?
    //@NSManaged public var path : [CLLocationCoordinate2D]?

}
