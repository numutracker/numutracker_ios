//
//  User.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/5/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import Foundation

class User {

    var album: String = "1"
    var single: String = "1"
    var ep: String = "1"
    var live: String = "1"
    var soundtrack: String = "1"
    var remix: String = "1"
    var other: String = "1"

    init?(username: String) {

        // Get filter info from json query...
        let json = SearchClient.sharedClient.getUserFilters(username: username)

        //print(json)

        guard let album = json["album"].string else {
            return nil
        }
        self.album = album

        guard let single = json["single"].string else {
            return nil
        }
        self.single = single

        guard let ep = json["ep"].string else {
            return nil
        }
        self.ep = ep

        guard let live = json["live"].string else {
            return nil
        }
        self.live = live

        guard let soundtrack = json["soundtrack"].string else {
            return nil
        }
        self.soundtrack = soundtrack

        guard let remix = json["remix"].string else {
            return nil
        }
        self.remix = remix

        guard let other = json["other"].string else {
            return nil
        }
        self.other = other


    }


}
