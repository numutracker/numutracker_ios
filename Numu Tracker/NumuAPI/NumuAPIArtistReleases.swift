//
//  NumuAPIArtistReleases.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/10/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuAPIArtistReleases {
    public var releases: [Release] = []
    private var lastResult: NumuAPIResult?
    private var artist: Artist

    init(artist: Artist) {
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