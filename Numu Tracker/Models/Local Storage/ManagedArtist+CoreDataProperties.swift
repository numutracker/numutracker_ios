//
//  ManagedArtist+CoreDataProperties.swift
//  
//
//  Created by Bradley Root on 2/16/19.
//
//

import Foundation
import CoreData

extension ManagedArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedArtist> {
        return NSFetchRequest<ManagedArtist>(entityName: "Artist")
    }

    @NSManaged public var mbid: UUID?
    @NSManaged public var name: String?
    @NSManaged public var nameSort: String?
    @NSManaged public var primaryArtUrl: URL?
    @NSManaged public var largeArtUrl: URL?

    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var following: Bool

    @NSManaged public var releases: Set<ManagedRelease>

}

// MARK: Generated accessors for releases
extension ManagedArtist {

    @objc(addReleasesObject:)
    @NSManaged public func addToReleases(_ value: ManagedRelease)

    @objc(removeReleasesObject:)
    @NSManaged public func removeFromReleases(_ value: ManagedRelease)

    @objc(addReleases:)
    @NSManaged public func addToReleases(_ values: NSSet)

    @objc(removeReleases:)
    @NSManaged public func removeFromReleases(_ values: NSSet)

}
