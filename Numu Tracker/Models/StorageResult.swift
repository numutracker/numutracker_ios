//
//  StorageResult.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/3/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

struct StorageResult {
    let offset: Int
    let resultsTotal: Int
    let resultsRemaining: Int

    let items: [Any]?
}
