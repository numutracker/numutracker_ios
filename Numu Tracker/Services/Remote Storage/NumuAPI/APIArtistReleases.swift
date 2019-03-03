//
//  APIArtistReleases.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/10/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class APIArtistReleases {
    public var releases: [APIRelease] = []
    private var lastResult: APIResult?
    private var artist: APIArtist

    init(artist: APIArtist) {
        self.artist = artist
    }

    public func reset() {
        self.releases.removeAll()
        self.lastResult = nil
    }

    public func get(completion: @escaping () -> Void) {
        NumuAPI.shared.getReleases(forArtist: self.artist, offset: 0) { (result) in
            if let result = result, let releases = result.userReleases {
                self.lastResult = result
                self.releases = releases
            }
            completion()
        }
    }

    public func isMoreAvailable() -> Bool {
        if let lastResult = self.lastResult, let resultsRemaining = lastResult.resultsRemaining, resultsRemaining > 0 {
            return true
        }
        if self.lastResult == nil {
            return true
        }
        return false
    }

    public func getMore(completion: @escaping () -> Void) {
        if let lastResult = self.lastResult, let resultsRemaining = lastResult.resultsRemaining, resultsRemaining > 0 {
            let releasesCount = self.releases.count
            NumuAPI.shared.getReleases(forArtist: self.artist, offset: releasesCount) { (result) in
                if let result = result, let releases = result.userReleases {
                    self.lastResult = result
                    self.releases += releases
                }
                completion()
            }
        }
        completion()
    }

}
