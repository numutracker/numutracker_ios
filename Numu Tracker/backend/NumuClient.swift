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
    
    static let shared = NumuClient()
    
    func getJSON(with endPoint: String, completion: @escaping (JSON) -> ()) {
        if let url = URL(string: urlPrefix + endPoint) {
            print(url)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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

    // MARK: - Account Related

    func authorizeLogIn(username: String, password: String, completion: @escaping (String) -> ()) {
        NumuCredential.shared.storeCredential(username: username, password: password)
        let endPoint = "/v2/json.php?auth=1"
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                completion(result)
            } else {
                // FIXME: API returns a string that fails JSON conversion.
                // When API doesn't do this, this check will fail.
                NumuCredential.shared.removeCredential()
                completion("Authorization Failure")
            }
        }
    }

    func authorizeRegister(username: String, password: String, completion: @escaping (String) -> ()) {
        let endPoint = "/v2/json.php?register=" + username + "&password=" + password
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                if result == "1" {
                    NumuCredential.shared.storeCredential(username: username, password: password)
                }
                completion(result)
            } else {
                // FIXME: API returns a string that fails JSON conversion.
                // When API doesn't do this, this check will fail.
                completion("Registration Failure")
            }
        }
    }

    // MARK: - User Related
    
    func getFilters(completion: @escaping (JSON) -> ()) {
        let endPoint = "/v2/json.php?filters"
        self.getJSON(with: endPoint) { (json) in
            completion(json)
        }
    }

    func getStats(completion: @escaping (JSON) -> ()) {
        let endPoint = "/v2/json.php?stats"
        self.getJSON(with: endPoint) { (json) in
            completion(json)
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

    func toggleListen(releaseId: String, completion: @escaping (String) -> ()) {
        let endPoint = "/v2/json.php?listen=" + releaseId
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                result == "1" ? completion("1") : completion("0")
            }
        }
    }

    func toggleFollow(artistMbid: String, completion: @escaping (String) -> ()) {
        let endPoint = "/v2/json.php?unfollow=" + artistMbid
        self.getJSON(with: endPoint) { (json) in
            if let result = json["result"].string {
                result != "0" ? completion(result) : completion("0")
            }
        }
    }

    // MARK: - Artist Related

    func getArtist(search: String, completion: @escaping ([ArtistItem]) -> ()) {
        let username = NumuCredential.shared.getUsername() ?? "0"
        let endPoint = "/v2/json.php?single_artist=" + username + "&search=" + search
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }

    func getArtists(sortBy: String, completion: @escaping ([ArtistItem]) -> ()) {
        if let username = NumuCredential.shared.getUsername() {
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
        let username = NumuCredential.shared.getUsername() ?? "0"
        let endPoint = "/v2/json.php?artist_search=\(username)&search=\(var_search!)"
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }

    func getArtistReleases(artist: String, completion: @escaping ([ReleaseItem]) -> ()) {
        let username = NumuCredential.shared.getUsername() ?? "0"
        let endPoint = "/v2/json.php?user=\(username)&rel_mode=artist&artist=\(artist)"
        self.getJSON(with: endPoint) { (json) in
            completion(.init(with: json))
        }
    }
    
    // MARK: - Release Related

    func getReleases(view: Int, slide: Int, page: Int = 1, limit: Int = 50, offset: Int = 0, completion: @escaping (ReleaseData) -> ()) {
        var endPoint: String
        let username = NumuCredential.shared.getUsername() ?? "0"

        switch (view, slide) {
        case (0, 0):
            // All Unlistened
            let logged = "/v2/json.php?user=\(username)&page=\(page)&rel_mode=allunlistened&limit=\(limit)&offset=\(offset)"
            let notLogged = "/v2/json.php?page=\(page)&rel_mode=allunlistened&limit=\(limit)&offset=\(offset)"
            endPoint = defaults.logged ? logged : notLogged
        case (0, 1):
            // All Released
            let logged = "/v2/json.php?user=\(username)&page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
            let notLogged = "/v2/json.php?page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
            endPoint = defaults.logged ? logged : notLogged
        case (0, 2):
            // All Upcoming
            let logged = "/v2/json.php?user=\(username)&page=\(page)&rel_mode=allupcoming&limit=\(limit)&offset=\(offset)"
            let notLogged = "/v2/json.php?page=\(page)&rel_mode=allupcoming&limit=\(limit)&offset=\(offset)"
            endPoint = defaults.logged ? logged : notLogged
        case (1, 0):
            // User Unlistened
            endPoint = "/v2/json.php?user=\(username)&rel_mode=unlistened&page=\(page)&limit=\(limit)&offset=\(offset)"
        case (1, 1):
            // User Released
            endPoint = "/v2/json.php?user=\(username)&rel_mode=user&page=\(page)&limit=\(limit)&offset=\(offset)"
        case (1, 2):
            // User Upcoming
            endPoint = "/v2/json.php?user=\(username)&rel_mode=upcoming&page=\(page)&limit=\(limit)&offset=\(offset)"
        case (1, 3):
            // User Fresh
            endPoint = "/v2/json.php?user=\(username)&rel_mode=fresh&page=\(page)&limit=\(limit)&offset=\(offset)"
        default:
            endPoint = "/v2/json.php?page=\(page)&rel_mode=all&limit=\(limit)&offset=\(offset)"
        }

        self.getJSON(with: endPoint) { (json) in
            if let releaseData = ReleaseData(json: json) {
                completion(releaseData)
            }
        }
    }

    // MARK: - Miscellaneous
    
    func getArt(completion: @escaping ([String]) -> ()) {
        let endPoint = "/v2/json.php?arts=1"
        self.getJSON(with: endPoint) { (json) in
            if let arts = json.array {
                completion(arts.flatMap { String(describing: $0) })
            }
        }
    }
    
    func getAppleMusicLink(artist: String?, album: String?, completion: @escaping (String) -> ()) {
        if let artist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let album = album?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = "https://itunes.apple.com/search?term=\(artist)%20\(album)&media=music&entity=album"
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let json = try? JSON(data: data),
                let results = json["results"][0]["collectionViewUrl"].string {
                    completion(results)
            }
        }
    }

    func getSpotifyLink(artist: String?, album: String?, completion: @escaping (String) -> ()) {
        if let artist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let album = album?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let urlString = "https://api.spotify.com/v1/search?q=artist:\(artist)%20album:\(album)&type=album"
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let json = try? JSON(data: data),
                let results = json["albums"]["items"][0]["external_urls"]["spotify"].string {
                    completion(results)
            }
        }
    }

}
