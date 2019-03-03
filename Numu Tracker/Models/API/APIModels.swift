//
//  APIModels.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/6/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let result: APIResult?
    let success: Bool
}

struct APIResult: Codable {
    let offset: Int?
    let resultsPerRequest: Int?
    let resultsRemaining: Int?
    let totalResults: Int?

    let message: String?

    let userArtists: [APIArtist]?
    let userReleases: [APIRelease]?
}

struct APIArtUrls: Codable {
    let thumbUrl: URL
    let fullUrl: URL
    let largeUrl: URL
}

struct APIServiceLinks: Codable {
    let appleMusicUrl: URL?
    let spotifyUrl: URL?
    let deezerUrl: URL?
}
