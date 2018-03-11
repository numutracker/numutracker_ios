//
//  SearchClient.swift
//  Numu Tracker
//
//  Created by Bradley Root on 8/28/16.
//  Copyright © 2016 Amiantos. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchClient {

    static let sharedClient = SearchClient()

    func getArtistReleases(artist: String, completion: @escaping ([ReleaseItem]) -> ()) {
        // Let's try swifty json...
        if defaults.logged {
            let username = defaults.username
            var urlString = "https://www.numutracker.com/v2/json.php?user=" + username!
            let urlString2 = "&rel_mode=artist&artist=\(artist)"
            urlString = urlString + urlString2
            //print(urlString)
            completion(.init(from: urlString))
        } else {

            let urlString = "https://www.numutracker.com/v2/json.php?user=0&rel_mode=artist&artist=\(artist)"
            completion(.init(from: urlString))

        }
    }

    func getRandomArts(completion: @escaping ([String]) -> ()) {
        let urlString = "https://www.numutracker.com/v2/json.php?arts=1"
        //print(urlString)
        var arts_found: [String] = []

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    if let arts = json.array {
                        for art in arts {
                            arts_found.append(art.string!)
                        }
                        completion(arts_found)
                    }
                }
            }
        }
    }



    func authorizeLogIn(username: String, password: String) -> String {
        let escapedString = username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://" + escapedString! + ":" + password + "@www.numutracker.com/v2/json.php?auth=1"
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

    func authorizeRegister(username: String, password: String) -> String {

        let urlString = "https://www.numutracker.com/v2/json.php?register=" + username + "&password=" + password
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSON(data: data) {
                    if let success = json["result"].string {
                        return success
                    }
                }

            }
        }
        return "0"
    }

    func toggleListenState(releaseId: String) -> String {

        if defaults.logged {
            let username = defaults.username
            let password = defaults.password
            let escapedString = username!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "https://" + escapedString! + ":" + password!
            let urlString2 = "@www.numutracker.com/v2/json.php?listen=" + releaseId
            //print(urlString + urlString2)
            if let url = URL(string: urlString + urlString2) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let success = json["result"].string {
                            return success
                        }
                    }

                }
            }
            return "0"

        }
        return "0"
    }

    func unfollowArtist(artistMbid: String) -> String {

        if defaults.logged {
            let username = defaults.username
            let password = defaults.password
            let escapedString = username!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "https://" + escapedString! + ":" + password!
            let urlString2 = "@www.numutracker.com/v2/json.php?unfollow=" + artistMbid
            //print(urlString + urlString2)
            if let url = URL(string: urlString + urlString2) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let success = json["result"].string {
                            return success
                        }
                    }

                }
            }
            return "0"

        }
        return "0"
    }

    func followArtist(artistMbid: String) -> String {

        if defaults.logged {
            let username = defaults.username
            let password = defaults.password
            let escapedString = username!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "https://" + escapedString! + ":" + password!
            let urlString2 = "@www.numutracker.com/v2/json.php?follow=" + artistMbid
            //print(urlString + urlString2)
            if let url = URL(string: urlString + urlString2) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        if let success = json["result"].string {
                            return success
                        }
                    }
                }
            }
            return "0"

        }
        return "0"
    }

    func getUserFilters(username: String) -> JSON {

        if defaults.logged {
            let username = defaults.username
            let password = defaults.password
            let escapedString = username!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "https://" + escapedString! + ":" + password!
            let urlString2 = "@www.numutracker.com/v2/json.php?filters"

            //print(urlString + urlString2)

            if let url = URL(string: urlString + urlString2) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        return json
                    }
                }
            }

        }
        return .null
    }

    func getUserStats(username: String) -> JSON {

        if defaults.logged {
            let username = defaults.username
            let password = defaults.password
            let escapedString = username!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "https://" + escapedString! + ":" + password!
            let urlString2 = "@www.numutracker.com/v2/json.php?stats"

            //print(urlString + urlString2)

            if let url = URL(string: urlString + urlString2) {
                if let data = try? Data(contentsOf: url) {
                    if let json = try? JSON(data: data) {
                        return json
                    }
                }
            }

        }
        return .null
    }


    func HTTPsendRequest(request: NSMutableURLRequest,
                         callback: @escaping (String, String?) -> Void) {
        let task = URLSession.shared
            .dataTask(with: request as URLRequest) {
                (data, response, error) -> Void in
                if error != nil {
                    callback("", error?.localizedDescription)
                } else {
                    callback(String(data: data!, encoding: .utf8)!, nil)
                }
        }

        task.resume()
    }

    func HTTPPostJSON(url: String,  data: NSData,
    callback: @escaping (String, String?) -> Void) {

        let request = NSMutableURLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data as Data
        HTTPsendRequest(request: request, callback: callback)
    }

}
