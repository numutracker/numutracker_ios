//
//  ListenSpotifyTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/17/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import Spartan
import SpotifyLogin

class ListenSpotifyTableViewCell: UITableViewCell {

    var release: APIRelease?
    var spotifyUrl: String?

    @IBOutlet weak var spotifyIcon: UIImageView!
    @IBOutlet weak var spotifyLabel: UILabel!
    @IBOutlet weak var spotifyButton: NumuModalButton!

    @IBAction func spotifyAction(_ sender: Any) {
        if let urlString = self.spotifyUrl {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }

    func configure(release: APIRelease) {
        self.release = release
        self.spotifyButton.isEnabled = false
        self.spotifyLabel.textColor = UIColor.init(white: 1, alpha: 0.1)
        self.spotifyIcon.image = self.spotifyIcon.image?.withRenderingMode(.alwaysTemplate)
        self.spotifyIcon.tintColor = UIColor.init(white: 1, alpha: 0.1)
        self.getSpotifyLink()
    }

    func getSpotifyLink() {
        if let artist = self.release?.artistNames,
            let album = self.release?.title {

            let query = "\(artist) \(album)"
            print(query)
            SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
                if token != nil {
                    Spartan.authorizationToken = token
                    Spartan.loggingEnabled = true
                    _ = Spartan.search(
                        query: query,
                        type: .album,
                        success: { (pagingObject: PagingObject<SimplifiedAlbum>) in

                        if !pagingObject.items.isEmpty {
                            let release = pagingObject.items[0]
                            self?.spotifyUrl = release.externalUrls["spotify"]
                            self?.spotifyButton.isEnabled = true
                            self?.spotifyLabel.textColor = .white
                            self?.spotifyIcon.tintColor = .white
                        }

                    }, failure: { (error) in
                        print(error)
                    })
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
