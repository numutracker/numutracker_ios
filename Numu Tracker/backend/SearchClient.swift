//
//  SearchClient.swift
//  Numu Tracker
//
//  Created by Bradley Root on 8/28/16.
//  Copyright © 2016 Amiantos. All rights reserved.
//

import Foundation
import SwiftyJSON

extension ReleaseItem : JSONCodable { }
extension ArtistItem: JSONCodable { }

extension Array where Element : JSONCodable {
    init(from url: String) {
        if let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let json = try? JSON(data: data),
            let arr = json.array  {
            self = arr.flatMap { Element(json: $0) }
        }
        else {
            self = []
        }
    }
}

class SearchClient {

    static let sharedClient = SearchClient()

    /*
    func getUserArtists(sortBy: String, completion: @escaping ([ArtistItem]) -> ()) {
        if defaults.logged {
            let username = defaults.username
            let urlString = "https://www.numutracker.com/v2/json.php?artists=" + username! + "&sortby=" + sortBy
            completion(.init(from: urlString))
        }
    }
 

    func getArtistSearch(search: String, completion: @escaping ([ArtistItem]) -> ()) {
        if defaults.logged {
            let username = defaults.username
            let var_search = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "https://www.numutracker.com/v2/json.php?artist_search=" + username! + "&search=" + var_search!
            completion(.init(from: urlString))

        } else {
            let var_search = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "https://www.numutracker.com/v2/json.php?artist_search=0&search=" + var_search!
            completion(.init(from: urlString))
        }
    }
     */

    func getSingleArtistItem(search: String, completion: @escaping ([ArtistItem]) -> ()) {
        if defaults.logged {
            let username = defaults.username
            let urlString = "https://www.numutracker.com/v2/json.php?single_artist=" + username! + "&search=" + search
            completion(.init(from: urlString))
        }
    }


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

    /*
    func toggleFilter(filter: String) -> String {
        
        // New version using credential storage
        
        if NumuCredential.checkForCredential() {
            
            print("Found Credential")
            
            let hostPrefix = "https://www.numutracker.com"
            let endPoint = "/v2/json.php?filter=" + filter
            
            let sessionConfiguration = URLSessionConfiguration.default
            //sessionConfiguration.urlCredentialStorage = URLCredentialStorage.shared
            let session = URLSession(configuration: sessionConfiguration)
            
            if let url = URL(string: hostPrefix + endPoint) {
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print(response)
                    }
                }
            
                task.resume()

            }
            
        } else {
            print("No Credential")
        }
 
        return "0"
    }
     */

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
