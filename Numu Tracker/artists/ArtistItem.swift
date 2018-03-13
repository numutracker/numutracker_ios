//
//  ArtistItem.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/15/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ArtistItem {

    let artistName: String
    let recentRelease: String
    let artistId: String
    let artistArtThumb: String
    let artistArtFull: String
    let artistArtLarge: String
    let artistArtXLarge: String
    var followStatus: String
    let thumbUrl: NSURL
    let unlistened: String
    let total_rels: String

    init?(json: JSON) {
        guard let artistId = json["artist_id"].string,
            let followStatus = json["follow_status"].string,
            let recentRelease = json["recent_date"].string,
            let unlistened = json["unread"].string,
            let total_rels = json["total_releases"].string,
            let artistName = json["name"].string else {
                return nil
        }

        self.artistId = artistId
        self.followStatus = followStatus
        self.artistName = artistName
        self.total_rels = total_rels
        self.unlistened = unlistened
        self.recentRelease = recentRelease

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

        if self.artistArtFull != "" {
            self.thumbUrl = NSURL(string: self.artistArtFull)!
        } else {
            self.thumbUrl = NSURL(string: "")!
        }
    }

    func unfollowArtist(completion: @escaping (String) -> ()) {
        NumuClient.shared.toggleFollow(artistMbid: self.artistId) { (result) in
            completion(result)
        }
    }
}
