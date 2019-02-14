//
//  ArtistMO+CoreDataProperties.swift
//  
//
//  Created by Brad Root on 2/13/19.
//
//

import Foundation
import CoreData


extension ArtistMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtistMO> {
        return NSFetchRequest<ArtistMO>(entityName: "Artist")
    }

    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var following: Bool
    @NSManaged public var mbid: UUID
    @NSManaged public var name: String
    @NSManaged public var nameSort: String
    @NSManaged public var dateUpdated: NSDate
    @NSManaged public var primaryArtUrl: URL
    @NSManaged public var releases: NSSet?

}

// MARK: Generated accessors for releases
extension ArtistMO {

    @objc(addReleasesObject:)
    @NSManaged public func addToReleases(_ value: ReleaseMO)

    @objc(removeReleasesObject:)
    @NSManaged public func removeFromReleases(_ value: ReleaseMO)

    @objc(addReleases:)
    @NSManaged public func addToReleases(_ values: NSSet)

    @objc(removeReleases:)
    @NSManaged public func removeFromReleases(_ values: NSSet)

}
