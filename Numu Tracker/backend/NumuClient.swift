//
//  NumuClient.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/10/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

class NumuClient {
    
    private let urlPrefix = "https://www.numutracker.com"
    
    static let sharedClient = NumuClient()
    
    func getJSON(with endPoint: String, completion: @escaping (JSON) -> ()) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        if let url = URL(string: urlPrefix + endPoint) {
            print(url)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let content = data {
                    do {
                        let json = try JSON(data: content)
                        completion(json)
                    } catch {
                        completion(JSON.null)
                        // TODO: Implement more robust error handling, like notifying the user when their user / password no longer works.
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    func postJSON(with endPoint: String, content: JSON) {
        
    }
    
    // MARK: - User Related
    
    func authorizeLogIn(username: String, password: String, completion: @escaping (String) -> ()) {
        NumuCredential.sharedClient.storeCredential(username: username, password: password)
        let endPoint = "/v2/json.php?auth=1"
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                completion(result)
            } else {
                // FIXME: API returns a string that fails JSON conversion.
                // When API doesn't do this, this check will fail.
                NumuCredential.sharedClient.removeCredential()
                completion("Authorization Failure")
            }
        }
    }

    func toggleFilter(filter: String, completion: @escaping (Bool) -> ()) {
        let endPoint = "/v2/json.php?filter=" + filter
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                result == "1" ? completion(true) : completion(false)
            }
        }
    }
    
    // MARK: - Artist Related

    func getUserArtists(sortBy: String, completion: @escaping ([ArtistItem]) -> ()) {
        if let username = NumuCredential.sharedClient.getUsername() {
            let endPoint = "/v2/json.php?artists=" + username + "&sortby=" + sortBy
            self.getJSON(with: endPoint) { (json) in
                completion(.init(with: json))
            }
        } else {
            completion([])
        }
    }

    func getArtistSearch(search: String, completion: @escaping ([ArtistItem]) -> ()) {
        let var_search = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let username = NumuCredential.sharedClient.getUsername() ?? "0"
        let endPoint = "/v2/json.php?artist_search=\(username)&search=\(var_search!)"
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }
    
    func getSingleArtistItem(search: String, completion: @escaping ([ArtistItem]) -> ()) {
        let username = NumuCredential.sharedClient.getUsername() ?? "0"
        let endPoint = "/v2/json.php?single_artist=" + username + "&search=" + search
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }
    
    func getArtistReleases(artist: String, completion: @escaping ([ReleaseItem]) -> ()) {
        let username = NumuCredential.sharedClient.getUsername() ?? "0"
        let endPoint = "/v2/json.php?user=\(username)&rel_mode=artist&artist=\(artist)"
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }
    
    // MARK: - Miscellaneous
    
    func getRandomArts(completion: @escaping ([String]) -> ()) {
        let endPoint = "/v2/json.php?arts=1"
        self.getJSON(with: endPoint) { (json) in
            if let arts = json.array {
                completion(arts.flatMap { String(describing: $0) })
            }
        }
    }

}
