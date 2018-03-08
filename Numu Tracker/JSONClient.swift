//
//  JSONHandling.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/29/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONClient {

    static let sharedClient = JSONClient()

    func postArtists(artists: [String], completion: @escaping (String) -> ()) {
        let json = ["artists": artists]
        do {

            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

            // create post request
            let username = defaults.string(forKey: "username")
            let password = defaults.string(forKey: "password")
            let escapedString = username?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let url = URL(string: "https://" + escapedString! + ":" + password! + "@www.numutracker.com/v2/json.php?import")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"

            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    //print("Error 1 -> \(String(describing: error))")
                    completion("Failure")
                }

                do {
                    if data != nil {
                        _ = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        //print("Result -> \(String(describing: result))")
                        completion("Success")
                    } else {
                        completion("Failure")
                    }

                } catch {
                    //print("Error 2 -> \(error)")
                    completion("Failure")
                }
            }

            task.resume()

        } catch {
            //print(error)
            completion("Failure")
        }
    }

    func getReleases(view: Int, slide: Int, page: Int = 1, limit: Int = 50, offset: Int = 0, completion: @escaping (ReleaseData) -> ()) {
        // Let's try swifty json...
        var urlString: String
        let username = defaults.string(forKey: "username") ?? ""

        switch view {
        case 0:
            switch slide {
            case 0:
                // All unlistened
                if defaults.bool(forKey: "logged") {
                    urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&page=\(page)&rel_mode=allunlistened&limit=\(limit)&offset=\(offset)"
                } else {
                    urlString = "https://www.numutracker.com/v2/json.php?page=\(page)&rel_mode=allunlistened&limit=\(limit)&offset=\(offset)"
                }
            case 1:
                // All released
                if defaults.bool(forKey: "logged") {
                    urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
                } else {
                    urlString = "https://www.numutracker.com/v2/json.php?page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
                }
            case 2:
                // All upcoming
                if defaults.bool(forKey: "logged") {
                    urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&page=\(page)&rel_mode=allupcoming&limit=\(limit)&offset=\(offset)"
                } else {
                    urlString = "https://www.numutracker.com/v2/json.php?page=\(page)&rel_mode=allupcoming&limit=\(limit)&offset=\(offset)"
                }
            default:
                urlString = "https://www.numutracker.com/v2/json.php?page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
            }

        case 1:
            switch slide {
            case 0:
                // User unlistened
                urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&rel_mode=unlistened&page=\(page)&limit=\(limit)&offset=\(offset)"
                //print(urlString)
            case 1:
                // User released
                urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&rel_mode=user&page=\(page)&limit=\(limit)&offset=\(offset)"
            case 2:
                // User upcoming
                urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&rel_mode=upcoming&page=\(page)&limit=\(limit)&offset=\(offset)"
            case 3:
                // User newly added
                urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&rel_mode=fresh&page=\(page)&limit=\(limit)&offset=\(offset)"
            default:
                urlString = "https://www.numutracker.com/v2/json.php?user=\(username)&rel_mode=unlistened&page=\(page)&limit=\(limit)&offset=\(offset)"
            }

        default:
            urlString = "https://www.numutracker.com/v2/json.php?page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
        }

        //print(urlString)

        var releases: ReleaseData

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    if let releaseData = ReleaseData(json: json) {
                        releases = releaseData
                        completion(releases)
                    }
                }
            }
        }
    }

    func getSpotifyLink(artist: String?, album: String?, completion: @escaping (String) -> ()) {
        if let artist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let album = album?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            // Generate spotify search string
            let urlString = "https://api.spotify.com/v1/search?q=artist:\(artist)%20album:\(album)&type=album"
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let url = json["albums"]["items"][0]["external_urls"]["spotify"].string {
                            completion(url)
                        }
                    }
                }
            }

        }
    }

    func getAppleMusicLink(artist: String?, album: String?, completion: @escaping (String) -> ()) {
        if let artist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let album = album?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // Generate spotify search string
            let urlString = "https://itunes.apple.com/search?term=\(artist)%20\(album)&media=music&entity=album"
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let url = json["results"][0]["collectionViewUrl"].string {
                            completion(url)
                        }
                    }
                }
            }

        }
    }

    func getSingleArtist(artist: String?, completion: @escaping (ArtistItem) -> ()) {

        if let artist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let urlString = "https://www.numutracker.com/artist/\(artist)"
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let artist = ArtistItem(json: json[0]) {
                            completion(artist)
                        }
                    }
                }
            }
        }
    }

    func processPurchase(username: String, password: String, purchased: String) -> String {
        let escapedString = username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://" + escapedString! + ":" + password + "@www.numutracker.com/v2/json.php?purchased=" + purchased
        //print(urlString)
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //print(data)
                if let json = try? JSON(data: data) {
                    if let success = json["result"].string {
                        return success
                    }
                }

            }
        }
        return "0"
    }

    func getSubStatus(username: String, password: String) -> [String] {
        let escapedString = username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://" + escapedString! + ":" + password + "@www.numutracker.com/v2/json.php?sub_status=1"
        //print(urlString)
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //print(data)
                if let json = try? JSON(data: data) {
                    if let success = json["result"].string, let sub_date = json["subscription_end"].string, let now_date = json["date_now"].string {
                        return [success,sub_date,now_date]
                    }
                }

            }
        }
        return []
    }
}
