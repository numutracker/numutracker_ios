//
//  ReleaseMO+CoreDataProperties.swift
//  
//
//  Created by Brad Root on 2/13/19.
//
//

import Foundation
import CoreData


extension ReleaseMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReleaseMO> {
        return NSFetchRequest<ReleaseMO>(entityName: "Release")
    }

    @NSManaged public var artistNames: String
    @NSManaged public var dateFollowed: NSDate?
    @NSManaged public var dateListened: NSDate?
    @NSManaged public var dateRelease: NSDate
    @NSManaged public var dateUpdated: NSDate
    @NSManaged public var following: Bool
    @NSManaged public var listened: Bool
    @NSManaged public var mbid: UUID
    @NSManaged public var title: String
    @NSManaged public var primaryArtUrl: URL
    @NSManaged public var appleMusicUri: URL?
    @NSManaged public var spotifyUri: URL?
    @NSManaged public var deezerUri: URL?
    @NSManaged public var artists: NSSet?

}

// MARK: Generated accessors for artists
extension ReleaseMO {

    @objc(addArtistsObject:)
    @NSManaged public func addToArtists(_ value: ArtistMO)

    @objc(removeArtistsObject:)
    @NSManaged public func removeFromArtists(_ value: ArtistMO)

    @objc(addArtists:)
    @NSManaged public func addToArtists(_ values: NSSet)

    @objc(removeArtists:)
    @NSManaged public func removeFromArtists(_ values: NSSet)

}
