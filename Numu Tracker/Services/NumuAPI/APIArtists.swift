//
//  APIArtists.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class APIArtists {
    public var artists: [APIArtist] = []
    private var lastResult: APIResult?

    public func reset() {
        self.artists.removeAll()
        self.lastResult = nil
    }

    // public func sort()

    public func get(completion: @escaping () -> Void) {
        NumuAPI.shared.getArtists(offset: 0) { (result) in
            if let result = result, let artists = result.userArtists {
                self.lastResult = result
                self.artists = artists
            }
            completion()
        }
    }
}
