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
    let page: Int
    let nextPage: Int?
    let prevPage: Int?
    let totalPages: Int
    let perPage: Int

    let message: String?

    let userArtists: [Artist]?
    let userReleases: [Release]?
}

struct ArtUrls: Codable {
    let thumbUrl: URL
    let fullUrl: URL
    let largeUrl: URL
}

struct Artist: Codable {
    let mbid: UUID
    let name: String
    let sortName: String
    let disambiguation: String?

    let dateUpdated: String
    let recentReleaseDate: String? // TODO: This should probably be returned by API always if possible.

    let art: ArtUrls

    let userData: ArtistUserData?
}

struct ArtistUserData: Codable {
    let uuid: UUID
    let following: Bool
    let listenedReleases: Int
    let totalReleases: Int
    let dateFollowed: String
    let dateUpdated: String
}

struct Release: Codable {
    let mbid: UUID
    let title: String
    let artistNames: String
    let type: String
    let dateAdded: String
    let dateRelease: String
    let dateUpdated: String

    let art: ArtUrls
    let artists: [Artist]

    let userDate: ReleaseUserData?
}

struct ReleaseUserData: Codable {
    let uuid: UUID
    let dateAdded: String
    let dateListened: String
    let dateUpdated: String
    let listened: Bool

    let userArtists: Artist?
}
