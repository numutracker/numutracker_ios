//
//  APIArtist.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/16/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct APIArtist: Codable {
    let mbid: UUID
    let name: String
    let sortName: String
    let disambiguation: String?

    let dateUpdated: Date

    let links: APIServiceLinks?

    let art: APIArtUrls?
    var primaryArtUrl: URL {
        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let artistArt = self.art {
            artUrl = artistArt.fullUrl
        }
        return artUrl!
    }
    var largeArtUrl: URL {
        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let artistArt = self.art {
            artUrl = artistArt.largeUrl
        }
        return artUrl!
    }

    let userData: APIArtistUserData?

    func toArtist() -> Artist {
        let dateUpdated =  self.userData?.dateUpdated ?? self.dateUpdated
        return Artist.init(
            mbid: mbid,
            name: name,
            nameSort: sortName,
            primaryArtUrl: primaryArtUrl,
            largeArtUrl: largeArtUrl,
            dateUpdated: dateUpdated,
            dateFollowed: userData?.dateFollowed,
            following: userData?.following ?? false)
    }
}

struct APIArtistUserData: Codable {
    var following: Bool
    let dateFollowed: Date
    let dateUpdated: Date
}
