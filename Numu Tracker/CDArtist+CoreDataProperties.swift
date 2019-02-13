//
//  CDArtist+CoreDataProperties.swift
//  
//
//  Created by Bradley Root on 2/12/19.
//
//

import Foundation
import CoreData


extension CDArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArtist> {
        return NSFetchRequest<CDArtist>(entityName: "CDArtist")
    }

    @NSManaged public var mbid: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sortName: String?
    @NSManaged public var totalReleases: Int16
    @NSManaged public var listenedReleases: Int16
    @NSManaged public var following: Bool
    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var releases: NSSet?

}

// MARK: Generated accessors for releases
extension CDArtist {

    @objc(addReleasesObject:)
    @NSManaged public func addToReleases(_ value: CDRelease)

    @objc(removeReleasesObject:)
    @NSManaged public func removeFromReleases(_ value: CDRelease)

    @objc(addReleases:)
    @NSManaged public func addToReleases(_ values: NSSet)

    @objc(removeReleases:)
    @NSManaged public func removeFromReleases(_ values: NSSet)

}
