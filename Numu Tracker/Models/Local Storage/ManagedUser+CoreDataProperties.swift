//
//  ManagedUser+CoreDataProperties.swift
//  
//
//  Created by Bradley Root on 2/17/19.
//
//

import Foundation
import CoreData

extension ManagedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var albumFilter: Bool
    @NSManaged public var epFilter: Bool
    @NSManaged public var singleFilter: Bool
    @NSManaged public var liveFilter: Bool
    @NSManaged public var soundtrackFilter: Bool
    @NSManaged public var remixFilter: Bool
    @NSManaged public var otherFilter: Bool
    @NSManaged public var dateLastActivity: NSDate?

}
