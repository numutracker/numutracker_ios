//
//  Release.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/16/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct Release {
    var mbid: UUID
    var title: String
    var artistNames: String
    var dateRelease: Date
    var primaryArtUrl: URL
    var largeArtUrl: URL

    var dateUpdated: Date

    var following: Bool?
    var dateFollowed: Date?
    var listened: Bool?
    var dateListened: Date?

    var appleMusicUrl: URL?
    var spotifyUrl: URL?
    var deezerUrl: URL?

    var artists: [Artist]
}

extension Release: Equatable {
    static func == (lhs: Release, rhs: Release) -> Bool {
        return lhs.mbid == rhs.mbid
    }
}
