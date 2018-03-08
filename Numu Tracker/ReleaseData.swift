//
//  ReleaseData.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/29/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReleaseData {
    let currentPage: String
    let totalPages: String
    let totalResults: String
    var results: [ReleaseItem] = []

    init?(json: JSON) {
        guard let currentPage = json["page"].string else {
            return nil;
        }
        self.currentPage = currentPage

        guard let totalPages = json["total_pages"].string else {
            return nil;
        }
        self.totalPages = totalPages

        guard let totalResults = json["total_results"].string else {
            return nil
        }
        self.totalResults = totalResults


        guard let results = json["results"].array else {
            return nil
        }

        for release in results {
            if let releaseFound = ReleaseItem(json: release) {
                self.results.append(releaseFound)
            }
        }

    }
}
