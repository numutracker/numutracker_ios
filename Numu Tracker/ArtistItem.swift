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

        guard let artistId = json["artist_id"].string else {
            return nil;
        }
        self.artistId = artistId

        guard let followStatus = json["follow_status"].string else {
            return nil;
        }
        self.followStatus = followStatus


        guard let recentRelease = json["recent_date"].string else {
            return nil;
        }
        self.recentRelease = recentRelease

        guard let unlistened = json["unread"].string else {
            return nil;
        }
        self.unlistened = unlistened

        guard let total_rels = json["total_releases"].string else {
            return nil;
        }
        self.total_rels = total_rels



        guard let artistName = json["name"].string else {
            return nil;
        }
        self.artistName = artistName

        if (json["artist_art"].int != 0 && json["artist_art"].int != 2) {

            guard let albumArtThumb = json["artist_art"]["thumb"].string else {
                return nil;
            }

            self.artistArtThumb = albumArtThumb

            guard let albumArtFull = json["artist_art"]["full"].string else {
                return nil;
            }

            self.artistArtFull = albumArtFull

            guard let albumArtLarge = json["artist_art"]["large"].string else {
                return nil;
            }

            self.artistArtLarge = albumArtLarge

            guard let albumArtXLarge = json["artist_art"]["xlarge"].string else {
                return nil;
            }

            self.artistArtXLarge = albumArtXLarge

        } else {

            self.artistArtThumb = ""
            self.artistArtFull = ""
            self.artistArtLarge = ""
            self.artistArtXLarge = ""

        }


        if (self.artistArtFull != "") {
            self.thumbUrl = NSURL(string: self.artistArtFull)!
        } else {
            self.thumbUrl = NSURL(string: "")!
        }

    }

    func unfollowArtist() -> String {

        let success = SearchClient.sharedClient.unfollowArtist(artistMbid: self.artistId)
        return success


    }


}
