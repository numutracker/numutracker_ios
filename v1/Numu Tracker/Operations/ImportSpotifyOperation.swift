//
//  ImportSpotifyOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/14/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import SpotifyLogin
import Spartan
import Crashlytics

class ImportSpotifyOperation: AsyncOperation {
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    var artistsImported: Int = 0
    var token: String?
    var artistObject: PagingObject<Artist>?
    var artists: [String] = []

    override func main() {
        print("Running ImportSpotifyOperation...")
        if !defaults.logged {
            self.state = .isFinished
            return
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getSpotifyTokenAndImport),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelOperation),
                                               name: .CancelledSpotifyLogin,
                                               object: nil)

        self.getSpotifyTokenAndImport()

    }

    @objc func cancelOperation() {
        self.state = .isFinished
    }

    @objc func getSpotifyTokenAndImport() {
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error != nil, token == nil {
                self?.showSpotifyLogin()
            } else {
                self?.grabSpotifyArtists(token: token)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func showSpotifyLogin() {
        let spotifyLogin = LoginSpotifyViewController()
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(spotifyLogin, animated: true, completion: nil)
            }
        }
    }

    func grabSpotifyArtists(token: String?) {
        print("Importing from Spotify")
        Spartan.authorizationToken = token
        Spartan.loggingEnabled = true
        self.grabTopSpotifyArtists(timeRange: .longTerm)
    }

    func grabTopSpotifyArtists(timeRange: TimeRange) {
        _ = Spartan.getMyTopArtists(limit: 50, offset: 0, timeRange: timeRange, success: { (object) in
            self.artistObject = object
            self.parseArtists()

            if timeRange == .longTerm {
                self.grabTopSpotifyArtists(timeRange: .mediumTerm)
            }

            if timeRange == .mediumTerm {
                self.grabTopSpotifyArtists(timeRange: .shortTerm)
            }

            if timeRange == .shortTerm {
                //self.grabSpotifyFollowedArtists()
                self.getFollowing(after: nil)
            }

        }, failure: { (error) in
            self.displaySpotifyError(error: error.errorMessage)
        })
    }

    func getFollowing(after: String?) {
        _ = Spartan.getMyFollowedArtists(limit: 10, after: after, success: { (pagingObject) in
             self.artistObject = pagingObject
             self.parseArtists()

            if pagingObject.canMakeNextRequest {
                usleep(100000)
                self.getFollowing(after: pagingObject.cursors?.after)
            } else {
                print(self.artists)
                self.sendArtistsToNumu()
            }
        }, failure: { (error) in
            self.displaySpotifyError(error: error.errorMessage)
        })
    }

    func parseArtists() {
        if let artists = self.artistObject?.items {
            for artist in artists {
                self.artists.append(artist.name!)
            }
        }
    }

    func sendArtistsToNumu() {
        let uniques = Array(Set(self.artists))
        let json = ["artists": uniques]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

            // create post request
            let url = URL(string: "https://www.numutracker.com/v2/json.php?import")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"

            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            dataTask = session.dataTask(with: request as URLRequest) {[weak self] (data, _, error) in
                guard let data = data else { return }
                do {
                    if let returnedJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if returnedJSON["success"] != nil {
                            NumuReviewHelper.incrementAndAskForReview()
                            self?.displaySuccessMessage()
                            DispatchQueue.main.async(execute: {
                                NotificationCenter.default.post(name: .UpdatedArtists, object: nil)
                                NotificationCenter.default.post(name: .LoggedIn, object: nil)
                                Answers.logCustomEvent(withName: "Spotify Artist Import")
                            })
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self?.state = .isFinished
            }

            dataTask?.resume()

        } catch {
            print(error.localizedDescription)
            self.state = .isFinished
        }
    }

    func displaySuccessMessage() {
        DispatchQueue.main.async {
            AlertModal(
                title: "Success",
                button: "Groovy",
                message: "Your artists have been imported. "
                        + "Please wait several minutes for all artists "
                        + "to appear in your collection."
            ).present()
        }
    }

    func displaySpotifyError(error: String) {
        DispatchQueue.main.async {
            AlertModal(
                title: "Error",
                button: "Oh no",
                message: error
            ).present()
            self.state = .isFinished
        }
    }
}
