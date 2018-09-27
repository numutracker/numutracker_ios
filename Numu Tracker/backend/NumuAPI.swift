//
//  NumuAPI.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation

class NumuAPI {
    
    private let urlPrefix = "https://www.numutracker.com"
    
    static let shared = NumuAPI()
    
    func getAuth() -> String {
        return urlPrefix + "/v2/json.php?auth=1"
    }

    func getFilters() -> String {
        return urlPrefix + "/v2/json.php?filters"
    }
    
    func getStats() -> String {
        return urlPrefix +  "/v2/json.php?stats"
    }

    func getArt() -> String {
        return urlPrefix + "/v2/json.php?arts=1"
    }
}
