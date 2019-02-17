//
//  APIReleases.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/8/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class APIReleases {
    public var releases: [APIRelease] = []
    private var lastResult: APIResult?
    public var releaseType: ReleaseType

    init(releaseType: ReleaseType) {
        self.releaseType = releaseType
    }

    public func reset() {
        self.releases.removeAll()
        self.lastResult = nil
    }

    public func get(completion: @escaping () -> Void) {
        NumuAPI.shared.getReleases(type: self.releaseType, offset: 0) { (result) in
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
            NumuAPI.shared.getReleases(type: self.releaseType, offset: releasesCount) { (result) in
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
