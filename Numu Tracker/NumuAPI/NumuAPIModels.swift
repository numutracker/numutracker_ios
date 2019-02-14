//
//  NumuAPIModels.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/6/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct NumuAPIResponse: Codable {
    let result: NumuAPIResult?
    let success: Bool
}

struct NumuAPIResult: Codable {
    let offset: Int?
    let resultsPerRequest: Int?
    let resultsRemaining: Int?
    let totalResults: Int?

    let message: String?

    let userArtists: [NumuAPIArtist]?
    let userReleases: [NumuAPIRelease]?
}

struct NumuAPIArtUrls: Codable {
    let thumbUrl: URL
    let fullUrl: URL
    let largeUrl: URL
}

struct NumuAPIArtist: Codable {
    let mbid: UUID
    let name: String
    let sortName: String
    let disambiguation: String?

    let dateUpdated: Date?
    let recentReleaseDate: Date? // TODO: This should probably be returned by API always if possible.

    let art: NumuAPIArtUrls?

    var primaryArtUrl: URL {
        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let artistArt = self.art {
            artUrl = artistArt.fullUrl
        }
        return artUrl!
    }

    let userData: NumuAPIArtistUserData?
}

struct NumuAPIArtistUserData: Codable {
    let uuid: UUID
    var following: Bool
    let listenedReleases: Float
    let totalReleases: Float
    let dateFollowed: Date
    let dateUpdated: Date
}

struct NumuAPIRelease: Codable {
    let mbid: UUID
    let title: String
    let artistNames: String
    let type: String
    let dateAdded: Date
    let dateRelease: Date
    let dateUpdated: Date

    let art: NumuAPIArtUrls?
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

    let artists: [NumuAPIArtist]

    var userData: NumuAPIReleaseUserData?
}

struct NumuAPIReleaseUserData: Codable {
    let uuid: UUID
    let dateFollowed: Date
    let dateListened: Date?
    let dateUpdated: Date
    var listened: Bool
    let following: Bool

    let userArtists: NumuAPIArtist?
}
