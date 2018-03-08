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
        guard let currentPage = json["page"].string,
            let totalPages = json["total_pages"].string,
            let totalResults = json["total_results"].string,
            let results = json["results"].array else {
            return nil
        }

        self.currentPage = currentPage
        self.totalPages = totalPages
        self.totalResults = totalResults

        self.results = results.flatMap { ReleaseItem(json: $0) }
    }
}
