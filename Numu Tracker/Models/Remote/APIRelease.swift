//
//  APIRelease.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/16/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct APIRelease: Codable {
    let mbid: UUID
    let title: String
    let artistNames: String
    let type: String
    let dateAdded: Date
    let dateRelease: Date
    let dateUpdated: Date

    let links: APIServiceLinks?

    let art: APIArtUrls?
    var primaryArtUrl: URL {
        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let releaseArt = self.art {
            artUrl = releaseArt.fullUrl
        } else {
            for artist in self.artists {
                if let artistArt = artist.art {
                    artUrl = artistArt.fullUrl
                }
            }
        }
        return artUrl!
    }
    var largeArtUrl: URL {
        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let releaseArt = self.art {
            artUrl = releaseArt.largeUrl
        } else {
            for artist in self.artists {
                if let artistArt = artist.art {
                    artUrl = artistArt.largeUrl
                }
            }
        }
        return artUrl!
    }

    let artists: [APIArtist]

    var userData: APIReleaseUserData?

    func toRelease() -> Release {
        let dateUpdated = self.userData?.dateUpdated ?? self.dateUpdated
        var artists: [Artist] = []
        for artist in self.artists {
            artists.append(artist.toArtist())
        }
        return Release.init(
            mbid: mbid,
            title: title,
            artistNames: artistNames,
            dateRelease: dateRelease,
            primaryArtUrl: primaryArtUrl,
            largeArtUrl: largeArtUrl,
            dateUpdated: dateUpdated,
            following: userData?.following,
            dateFollowed: userData?.dateFollowed,
            listened: userData?.listened,
            dateListened: userData?.dateListened,
            appleMusicUrl: links?.appleMusicUrl,
            spotifyUrl: links?.spotifyUrl,
            deezerUrl: links?.deezerUrl,
            artists: artists
        )
    }
}

struct APIReleaseUserData: Codable {
    let dateFollowed: Date
    let dateListened: Date?
    let dateUpdated: Date
    var listened: Bool
    let following: Bool

    let userArtists: APIArtist?
}
