//
//  ImportSpotifyViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import SpotifyLogin
import Spartan

class ImportSpotifyViewController: UIViewController {
    
    var artists: PagingObject<Artist>? {
        didSet {
            print("Added more to artists variable.")
        }
    }
    
    @IBOutlet weak var importSpotifyIndicator: UIActivityIndicatorView!
    @IBAction func importSpotifyAction(_ sender: Any) {
        print("Trying to import from Spotify...")
        // SpotifyLogin.shared.logout()
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error != nil, token == nil {
                let spotifyLogin = LoginSpotifyViewController()
                self!.show(spotifyLogin, sender: nil)
            } else {
                self!.grabSpotifyArtists(token: token)
            }
        }
    }
    
    func grabSpotifyArtists(token: String?) {
        Spartan.authorizationToken = token
        Spartan.loggingEnabled = true

        _ = Spartan.getMyTopArtists(limit: 10, offset: 0, timeRange: .longTerm, success: { (object) in
            self.artists = object
            self.printArtists()
            self.fetchAllItems()
        }, failure: { (error) in
            print(error)
        })

    }
    
    func fetchAllItems() {
        if let artists = self.artists {
            if artists.canMakeNextRequest {
                artists.getNext(success: { (object) in
                    self.artists = object
                    self.printArtists()
                    self.fetchAllItems()
                }) { (error) in
                    print(error)
                }
            }
        }
    }
    
    func printArtists() {
        if let artists = self.artists?.items {
            for artist in artists {
                print(artist.name)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error != nil {
                let spotifyLogin = LoginSpotifyViewController()
                self!.show(spotifyLogin, sender: nil)
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
