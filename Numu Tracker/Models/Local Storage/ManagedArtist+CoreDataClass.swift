//
//  ManagedArtist+CoreDataClass.swift
//  
//
//  Created by Bradley Root on 2/16/19.
//
//

import Foundation
import CoreData

@objc(ManagedArtist)
public class ManagedArtist: NSManagedObject {

    func toArtist() -> Artist {
        return Artist.init(
            mbid: mbid!,
            name: name!,
            nameSort: nameSort!,
            primaryArtUrl: primaryArtUrl!,
            largeArtUrl: largeArtUrl!,
            dateUpdated: dateUpdated! as Date,
            dateFollowed: dateFollowed as Date?,
            following: following
        )
    }

    func fromArtist(artist: Artist) {
        mbid = artist.mbid
        name = artist.name
        nameSort = artist.nameSort
        primaryArtUrl = artist.primaryArtUrl
        largeArtUrl = artist.largeArtUrl
        dateFollowed = artist.dateFollowed as NSDate?
        dateUpdated = artist.dateUpdated as NSDate?
        following = artist.following
    }

}
