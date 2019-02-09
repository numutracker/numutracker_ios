//
//  NumuAPIReleases.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/8/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuAPIReleases {
    public var releases: [Release] = []
    private var lastResult: NumuAPIResult?
    private var releaseType: ReleaseType

    init(releaseType: ReleaseType) {
        self.releaseType = releaseType
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
        if let lastResult = self.lastResult, let resultsRemaining = lastResult.resultsRemaining {
            let releasesCount = self.releases.count
            if resultsRemaining > 0 {
                NumuAPI.shared.getReleases(type: self.releaseType, offset: releasesCount) { (result) in
                    if let result = result, let releases = result.userReleases {
                        self.lastResult = result
                        self.releases += releases
                    }
                    completion()
                }
            }
        } else {
            completion()
        }
    }

}
