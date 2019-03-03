//
//  ManagedRelease+CoreDataProperties.swift
//  
//
//  Created by Bradley Root on 2/16/19.
//
//

import Foundation
import CoreData

extension ManagedRelease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedRelease> {
        return NSFetchRequest<ManagedRelease>(entityName: "Release")
    }

    @NSManaged public var mbid: UUID?
    @NSManaged public var title: String?
    @NSManaged public var artistNames: String?
    @NSManaged public var dateRelease: NSDate?
    @NSManaged public var primaryArtUrl: URL?
    @NSManaged public var largeArtUrl: URL?

    @NSManaged public var dateUpdated: NSDate?

    @NSManaged public var following: Bool
    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var listened: Bool
    @NSManaged public var dateListened: NSDate?

    @NSManaged public var appleMusicUrl: URL?
    @NSManaged public var deezerUrl: URL?
    @NSManaged public var spotifyUrl: URL?

    @NSManaged public var artists: Set<ManagedArtist>

}

// MARK: Generated accessors for artists
extension ManagedRelease {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: ManagedArtist)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: ManagedArtist)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}
