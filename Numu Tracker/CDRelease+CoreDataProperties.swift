//
//  CDRelease+CoreDataProperties.swift
//  
//
//  Created by Bradley Root on 2/12/19.
//
//

import Foundation
import CoreData


extension CDRelease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRelease> {
        return NSFetchRequest<CDRelease>(entityName: "CDRelease")
    }

    @NSManaged public var mbid: UUID?
    @NSManaged public var dateRelease: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var artistsString: String?
    @NSManaged public var listened: Bool
    @NSManaged public var dateListened: NSDate?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var followed: Bool
    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var artists: NSSet?

}

// MARK: Generated accessors for artists
extension CDRelease {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: CDArtist)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: CDArtist)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}
