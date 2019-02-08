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

class NumuAPI {

    static let shared = NumuAPI()

    fileprivate func getResponse(url: URL, withCompletion completion: @escaping (NumuAPIResponse?) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion(nil)
                    return
            }
            do {
                let response = try JSONDecoder().decode(NumuAPIResponse.self, from: dataResponse)
                completion(response)
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil)
            }
        }
        task.resume()
    }

    public func getReleases(type: ReleaseType, offset: Int) {
        let urlPrefix = "https://api.numutracker.com/v3"
        guard let resourceUrl = URL(string: urlPrefix + type.rawValue) else { return }

        getResponse(url: resourceUrl) { response in
            guard let releases = response?.result?.userReleases else { return }

            for release in releases {
                print(release.artistNames, release.title)
            }
        }

    }
}
