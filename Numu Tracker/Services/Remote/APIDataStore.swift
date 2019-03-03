//
//  APIDataStore.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class APIDataStore: NumuDataProtocol {

    let urlPrefix = "https://api.numutracker.com/v3"
    let apiKey = "0efaacb4-14dd-40d4-a6bd-379f8783c853"  // development API key

    fileprivate func buildURLRequest(endpoint: String, parameters: [String: String]) -> URLRequest {
        var components = URLComponents(string: urlPrefix + endpoint)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        print(components.url!)
        return URLRequest(url: components.url!)
    }

    fileprivate func getResponse(request: URLRequest, completionHandler: @escaping (APIResponse?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completionHandler(nil)
                    return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.numuDate)
                let response = try decoder.decode(APIResponse.self, from: dataResponse)
                completionHandler(response)
            } catch let parsingError {
                print("Parsing Error", parsingError)
                completionHandler(nil)
            }
        }
        task.resume()
    }

    func processResponse(_ response: APIResponse) -> APIResult? {
        if response.success == true {
            return response.result
        }
        print(String(describing: response.result?.message))
        return nil
    }

    func fetchArtists(sinceDateUpdated: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        var parameters = ["offset": "0"]
        if let date = sinceDateUpdated {
            parameters["date_offset"] = String(describing: Int(date.timeIntervalSince1970))
        }
        let request = buildURLRequest(endpoint: "/user/artists", parameters: parameters)
        getResponse(request: request) { (response) in
            guard let response = response else {
                completionHandler([], NumuStoreError.cannotFetch("Error fetching artists"))
                return
            }
            if let result = self.processResponse(response), let apiArtists = result.userArtists {
                let artists = apiArtists.map { $0.toArtist() }
                completionHandler(artists, nil)
            }
        }
    }

    func fetchReleases(sinceDateUpdated: Date?, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        var parameters = ["offset": "0"]
        if let date = sinceDateUpdated {
            parameters["date_offset"] = String(describing: Int(date.timeIntervalSince1970))
        }
        let request = buildURLRequest(endpoint: "/user/releases", parameters: parameters)
        getResponse(request: request) { (response) in
            guard let response = response else {
                completionHandler([], NumuStoreError.cannotFetch("Error fetching releases"))
                return
            }
            if let result = self.processResponse(response), let apiReleases = result.userReleases {
                let releases = apiReleases.map { $0.toRelease() }
                completionHandler(releases, nil)
            }
        }
    }

    // TODO: - Implement Protocol

    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func createUser(userToCreate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping ([ArtistImport], NumuStoreError?) -> Void) {
        <#code#>
    }

}
