//
//  NumuWorker.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuWorker {
    var numuStore: NumuStorageProtocol

    init(numuStore: NumuStorageProtocol) {
        self.numuStore = numuStore
    }

}

