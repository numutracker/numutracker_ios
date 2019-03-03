//
//  NumuAPI.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/6/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

enum ReleaseType: String {
    case unlistened = "/user/releases/unlistened"
    case released = "/user/releases/all"
    case upcoming = "/user/releases/upcoming"
    case newAdditions = "/user/releases/new"
}

extension DateFormatter {
    static let numuDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy H:m:s z"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

class NumuAPI {

    let urlPrefix = "https://api.numutracker.com/v3"

    static let shared = NumuAPI()

    fileprivate func getResponse(url: URL, withCompletion completion: @escaping (APIResponse?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(nil)
                    return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.numuDate)
                let response = try decoder.decode(APIResponse.self, from: dataResponse)
                completion(response)
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil)
            }
        }
        task.resume()
    }

    fileprivate func processResponse(response: APIResponse) -> APIResult? {
        if response.success == true {
            return response.result
        }
        print(String(describing: response.result?.message))
        return nil
    }

    public func getReleases(type: ReleaseType, offset: Int, withCompletion completion: @escaping (APIResult?) -> Void) {
        guard let resourceUrl = URL(string: urlPrefix + type.rawValue + "/\(offset)") else {
            completion(nil)
            return
        }
        print(resourceUrl)
        self.getResponse(url: resourceUrl) { response in
            guard let response = response else {
                completion(nil)
                return
            }
            let result = self.processResponse(response: response)
            completion(result)
        }
    }

    public func getReleases(forArtist artist: APIArtist, offset: Int, withCompletion completion: @escaping (APIResult?) -> Void) {
        let urlString = urlPrefix + "/user/artist/" + artist.mbid.uuidString.lowercased() + "/releases/\(offset)"
        guard let resourceUrl = URL(string: urlString) else {
            completion(nil)
            return
        }
        print(resourceUrl)
        self.getResponse(url: resourceUrl) { (response) in
            guard let response = response else {
                completion(nil)
                return
            }
            let result = self.processResponse(response: response)
            completion(result)
        }
    }

    public func getArtists(offset: Int, withCompletion completion: @escaping (APIResult?) -> Void) {
        guard let resourceUrl = URL(string: urlPrefix + "/user/artists" + "/\(offset)") else {
            completion(nil)
            return
        }
        print(resourceUrl)
        self.getResponse(url: resourceUrl) { (response) in
            guard let response = response else {
                completion(nil)
                return
            }
            let result = self.processResponse(response: response)
            completion(result)
        }
    }

}
