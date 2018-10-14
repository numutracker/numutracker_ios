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
                self.grabSpotifyFollowedArtists()
            }
            
        }, failure: { (error) in
            self.displaySpotifyError(error: error.errorMessage)
        })
    }
    
    func grabSpotifyFollowedArtists() {
        _ = Spartan.getMyFollowedArtists(limit: 50, after: nil, success: { (object) in
            self.artistObject = object
            self.parseArtists()
            self.fetchAllItems()
        }, failure: { (error) in
            self.displaySpotifyError(error: error.errorMessage)
        })
    }

    func fetchAllItems() {
        if let artists = self.artistObject {
            if artists.canMakeNextRequest {
                artists.getNext(success: { (object) in
                    self.artistObject = object
                    self.parseArtists()
                    self.fetchAllItems()
                }, failure: { (error) in
                    print(error)
                })
            } else {
                print(self.artists)
                self.sendArtistsToNumu()
            }
        }
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
                        if let success = returnedJSON["success"] {
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
            let alertView = NumuAlertView()
            alertView.providesPresentationContextTransitionStyle = true
            alertView.definesPresentationContext = true
            alertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func displaySpotifyError(error: String) {
        DispatchQueue.main.async {
            let alertView = NumuAlertView()
            alertView.providesPresentationContextTransitionStyle = true
            alertView.definesPresentationContext = true
            alertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            alertView.titleText = "Error"
            alertView.messageText = error
            alertView.buttonText = "Oh no"
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertView, animated: true, completion: nil)
            }
            self.state = .isFinished
        }
    }
}
