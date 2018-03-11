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
    
    static let sharedClient = NumuClient()
    
    private let urlPrefix = "https://www.numutracker.com"
    
    func getJSON(endPoint: String, completion: @escaping (JSON) -> ()) {
        if NumuCredential.checkForCredential() {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            if let url = URL(string: urlPrefix + endPoint) {
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if let content = data {
                            do {
                                let json = try JSON(data: content)
                                completion(json)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    task.resume()
            }
        } else {
            completion(JSON.null)
        }
    }
    
    func toggleFilter(filter: String, completion: @escaping (Bool) -> ()) {
        let endPoint = "/v2/json.php?filter=" + filter
        self.getJSON(endPoint: endPoint) { (json) in
            if let result = json["result"].string {
                result == "1" ? completion(true) : completion(false)
            }
        }
    }
    
    func getUserArtists(sortBy: String, completion: @escaping ([ArtistItem]) -> ()) {
        if let username = NumuCredential.getUsername() {
            let endPoint = "/v2/json.php?artists=" + username + "&sortby=" + sortBy
            self.getJSON(endPoint: endPoint) { (json) in
                if let arr = json.array {
                    let artists = arr.flatMap { ArtistItem(json: $0) }
                    completion(artists)
                }
            }
        } else {
            completion([])
        }
    }
    
}
