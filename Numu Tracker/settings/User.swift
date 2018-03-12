//
//  User.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/5/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {

    var album: String = "1"
    var single: String = "1"
    var ep: String = "1"
    var live: String = "1"
    var soundtrack: String = "1"
    var remix: String = "1"
    var other: String = "1"

    init?(json: JSON) {

        guard let album = json["album"].string,
            let single = json["single"].string,
            let ep = json["ep"].string,
            let live = json["live"].string,
            let soundtrack = json["soundtrack"].string,
            let remix = json["remix"].string,
            let other = json["other"].string else {
            return nil
        }
        
        self.album = album
        self.single = single
        self.ep = ep
        self.live = live
        self.soundtrack = soundtrack
        self.remix = remix
        self.other = other

    }
    
}
