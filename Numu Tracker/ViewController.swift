//
//  ViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    struct NumuAPIResponse: Codable {
        let result: NumuAPIResult?
        let success: Bool
    }

    struct NumuAPIResult: Codable {
        let page: Int
        let nextPage: Int?
        let prevPage: Int?
        let totalPages: Int
        let perPage: Int

        let message: String?
        
        let artists: [Artist]?
        let releases: [Release]?
    }
    
    struct ArtUrls: Codable {
        let fullUrl: URL
        let thumbUrl: URL
        let largeUrl: URL
    }
    
    struct Artist: Codable {
        let art: ArtUrls
        let dateUpdated: String
        let disambiguation: String?
        let mbid: UUID
        let name: String
        let recentReleaseDate: String? // TODO: Fix this in API...
        let sortName: String
        
        let userData: ArtistUserData?
    }
    
    struct ArtistUserData: Codable {
        let dateFollowed: String
        let dateUpdated: String
        let following: Bool
        let listenedReleases: Int
        let totalReleases: Int
        let uuid: UUID
    }
    
    struct Release: Codable {
        let art: ArtUrls
        let artistNames: String
        let artists: [Artist]
        let dateAdded: String
        let dateRelease: String
        let dateUpdated: String
        let mbid: UUID
        let title: String
        let type: String
        
        let userDate: ReleaseUserData?
    }
    
    struct ReleaseUserData: Codable {
        let dateAdded: String
        let dateListened: String
        let dateUpdated: String
        let listened: Bool
        let uuid: UUID
        
        let userArtists: Artist?
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(NumuCredential.shared.getV2Details())
        
        NumuCredential.shared.storeCredential(username: "test@test.com", password: "TestingP@ssword")
        
        if let url = URL(string: "https://api.numutracker.com/v3/user/releases/unlistened") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                }
                do {
                    let response = try JSONDecoder().decode(NumuAPIResponse.self, from: dataResponse)
                    
                    guard let releases = response.result?.releases else { return }
                    
                    for release in releases {
                        print(release.artistNames, release.title)
                    }
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }
        
    }


}

