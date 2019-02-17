//
//  Artist.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/16/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct Artist {
    var mbid: UUID
    var name: String
    var nameSort: String

    var primaryArtUrl: URL
    var largeArtUrl: URL

    var dateUpdated: Date

    var dateFollowed: Date?
    var following: Bool
}

extension Artist: Equatable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.mbid == rhs.mbid
    }
}
