//
//  NumuClient.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/10/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Array where Element : JSONCodable {
    init(with json: JSON) {
        if let arr = json.array {
            self = arr.flatMap { Element(json: $0) }
        } else {
            self = []
        }
    }
}

class NumuClient {
    
    private let urlPrefix = "https://www.numutracker.com"
    
    static let sharedClient = NumuClient()
    
    func getJSON(with endPoint: String, completion: @escaping (JSON) -> ()) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        if let url = URL(string: urlPrefix + endPoint) {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let content = data {
                    do {
                        let json = try JSON(data: content)
                        completion(json)
                    } catch {
                        completion(JSON.null)
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
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
        if let username = NumuCredential.sharedClient.getUsername() {
            let var_search = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let endPoint = "/v2/json.php?artist_search=" + username + "&search=" + var_search!
            self.getJSON(with: endPoint) { (json) in
                completion(.init(with: json))
            }
        } else {
            let var_search = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let endPoint = "/v2/json.php?artist_search=0&search=" + var_search!
            self.getJSON(with: endPoint) { (json) in
                completion(.init(with: json))
            }
        }
    }
    
}
