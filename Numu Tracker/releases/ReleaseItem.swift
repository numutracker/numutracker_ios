//
//  ReleaseItem.swift
//  Numu Tracker
//
//  Created by Bradley Root on 8/28/16.
//  Copyright © 2016 Amiantos. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONCodable {
    init?(json: JSON)
}

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

        guard let artistId = json["artist_id"].string,
            let albumName = json["title"].string,
            let releaseId = json["release_id"].string,
            let releaseDate = json["date"].string,
            let releaseType = json["type"].string,
            let artistName = json["artist"].string else {
                return nil
        }

        self.artistId = artistId
        self.albumName = albumName
        self.releaseId = releaseId
        self.releaseDate = releaseDate
        self.releaseType = releaseType
        self.artistName = artistName

        if json["art"].int != 0 && json["art"].int != 2 {

            guard let albumArtThumb = json["art"]["thumb"].string,
                let albumArtFull = json["art"]["full"].string,
                let albumArtLarge = json["art"]["large"].string,
                let albumArtXLarge = json["art"]["xlarge"].string else {
                    return nil
            }

            self.albumArtThumb = albumArtThumb
            self.albumArtFull = albumArtFull
            self.albumArtLarge = albumArtLarge
            self.albumArtXLarge = albumArtXLarge

        } else {

            self.albumArtThumb = ""
            self.albumArtFull = ""
            self.albumArtLarge = ""
            self.albumArtXLarge = ""
        }

        if json["artist_art"].int != 0 && json["artist_art"].int != 2 {

            guard let albumArtThumb = json["artist_art"]["thumb"].string,
                let albumArtFull = json["artist_art"]["full"].string,
                let albumArtLarge = json["artist_art"]["large"].string,
                let albumArtXLarge = json["artist_art"]["xlarge"].string else {
                    return nil
            }

            self.artistArtThumb = albumArtThumb
            self.artistArtFull = albumArtFull
            self.artistArtLarge = albumArtLarge
            self.artistArtXLarge = albumArtXLarge
        } else {
            self.artistArtThumb = ""
            self.artistArtFull = ""
            self.artistArtLarge = ""
            self.artistArtXLarge = ""
        }

        self.listenStatus = json["status"].string ?? "0"

        if self.albumArtThumb == "https://www.numutracker.com/nonly3-1024.png" {
            self.thumbUrl = NSURL(string: self.artistArtFull)!
        } else if self.albumArtThumb != "" {
            self.thumbUrl = NSURL(string: self.albumArtFull)!
        } else {
            self.thumbUrl = NSURL(string: "")!
        }

    }

    func toggleListenStatus(completion: @escaping (String) -> ()) {
        NumuClient.shared.toggleListenState(releaseId: self.releaseId) { (result) in
            completion(result)
        }
    }

}

