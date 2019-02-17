//
//  ManagedRelease+CoreDataClass.swift
//  
//
//  Created by Bradley Root on 2/16/19.
//
//

import Foundation
import CoreData

@objc(ManagedRelease)
public class ManagedRelease: NSManagedObject {

    func toRelease() -> Release {
        var artists: [Artist] = []
        for case let artist as ManagedArtist in self.artists! {
            artists.append(artist.toArtist())
        }
        return Release.init(
            mbid: mbid!,
            title: title!,
            artistNames: artistNames!,
            dateRelease: dateRelease! as Date,
            primaryArtUrl: primaryArtUrl!,
            largeArtUrl: largeArtUrl!,
            dateUpdated: dateUpdated! as Date,
            following: following,
            dateFollowed: dateFollowed! as Date,
            listened: listened,
            dateListened: dateListened! as Date,
            appleMusicUrl: appleMusicUrl,
            spotifyUrl: spotifyUrl,
            deezerUrl: deezerUrl,
            artists: artists)
    }

    func fromRelease(release: Release) {
        dateUpdated = release.dateUpdated as NSDate

        following = release.following!
        dateFollowed = release.dateFollowed as NSDate?
        listened = release.listened!
        dateListened = release.dateListened as NSDate?

        appleMusicUrl = release.appleMusicUrl
        deezerUrl = release.deezerUrl
        spotifyUrl = release.spotifyUrl
    }
}
