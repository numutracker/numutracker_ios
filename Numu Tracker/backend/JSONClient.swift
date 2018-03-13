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
            let username = defaults.username
            let password = defaults.password
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

}
