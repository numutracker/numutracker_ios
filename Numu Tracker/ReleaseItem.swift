//
//  ReleaseItem.swift
//  Numu Tracker
//
//  Created by Bradley Root on 8/28/16.
//  Copyright © 2016 Amiantos. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReleaseItem {
    let artistName: String
    let artistId: String
    let albumName: String
    let releaseDate: String
    let releaseId: String
    let albumArtThumb: String
    let albumArtFull: String
    let albumArtLarge: String
    let albumArtXLarge: String
    let artistArtThumb: String
    let artistArtFull: String
    let artistArtLarge: String
    let artistArtXLarge: String
    let releaseType: String
    let thumbUrl: NSURL
    var listenStatus: String

    init?(json: JSON) {

        guard let artistId = json["artist_id"].string else {
            return nil
        }
        self.artistId = artistId

        guard let albumName = json["title"].string else {
            return nil
        }
        self.albumName = albumName


        guard let releaseId = json["release_id"].string else {
            return nil
        }
        self.releaseId = releaseId


        guard let releaseDate = json["date"].string else {
            return nil
        }
        self.releaseDate = releaseDate

        guard let releaseType = json["type"].string else {
            return nil
        }
        self.releaseType = releaseType


        guard let artistName = json["artist"].string else {
            return nil
        }
        self.artistName = artistName


        if (json["art"].int != 0 && json["art"].int != 2) {

        guard let albumArtThumb = json["art"]["thumb"].string else {
            return nil
        }

        self.albumArtThumb = albumArtThumb

        guard let albumArtFull = json["art"]["full"].string else {
            return nil
        }

        self.albumArtFull = albumArtFull

        guard let albumArtLarge = json["art"]["large"].string else {
            return nil
        }

        self.albumArtLarge = albumArtLarge

        guard let albumArtXLarge = json["art"]["xlarge"].string else {
            return nil
        }

        self.albumArtXLarge = albumArtXLarge

        } else {

            self.albumArtThumb = ""
            self.albumArtFull = ""
            self.albumArtLarge = ""
            self.albumArtXLarge = ""

        }


        if (json["artist_art"].int != 0 && json["artist_art"].int != 2) {

            guard let albumArtThumb = json["artist_art"]["thumb"].string else {
                return nil
            }

            self.artistArtThumb = albumArtThumb

            guard let albumArtFull = json["artist_art"]["full"].string else {
                return nil
            }

            self.artistArtFull = albumArtFull

            guard let albumArtLarge = json["artist_art"]["large"].string else {
                return nil
            }

            self.artistArtLarge = albumArtLarge

            guard let albumArtXLarge = json["artist_art"]["xlarge"].string else {
                return nil
            }

            self.artistArtXLarge = albumArtXLarge

        } else {

            self.artistArtThumb = ""
            self.artistArtFull = ""
            self.artistArtLarge = ""
            self.artistArtXLarge = ""

        }

        if let status = json["status"].string {
            self.listenStatus = status
        } else {
            self.listenStatus = "0"
        }

        if (self.albumArtThumb == "https://www.numutracker.com/nonly3-1024.png") {
            self.thumbUrl = NSURL(string: self.artistArtFull)!
        } else if (self.albumArtThumb != "") {
            self.thumbUrl = NSURL(string: self.albumArtFull)!
        } else {
            self.thumbUrl = NSURL(string: "")!
        }

    }

    func toggleListenStatus() -> String {

        let success = SearchClient.sharedClient.toggleListenState(releaseId: self.releaseId)

        return success


    }

}
