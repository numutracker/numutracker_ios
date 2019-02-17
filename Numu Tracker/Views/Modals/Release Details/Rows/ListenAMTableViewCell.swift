//
//  ListenAMTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/14/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class ListenAMTableViewCell: UITableViewCell {

    var release: APIRelease?
    var itunesUrl: String?

    @IBOutlet weak var listenButtonOutlet: NumuModalButton!
    @IBAction func listenButton(_ sender: Any) {
        if let urlString = self.itunesUrl {
            UIApplication.shared.open(URL(string: urlString + "&app=music")!)
        }
    }
    @IBOutlet weak var listenButtonLabel: UILabel!
    @IBOutlet weak var listenButtonIcon: UIImageView!

    func configure(release: APIRelease) {
        self.release = release
        self.listenButtonOutlet.isEnabled = false
        self.listenButtonLabel.textColor = UIColor.init(white: 1, alpha: 0.1)
        self.listenButtonIcon.image = self.listenButtonIcon.image?.withRenderingMode(.alwaysTemplate)
        self.listenButtonIcon.tintColor = UIColor.init(white: 1, alpha: 0.1)
        self.getItunesLink()
    }

    func getItunesLink() { /*
        let artist = self.release?.artistNames
        let album = self.release?.title
        DispatchQueue.global(qos: .background).async(execute: {
            NumuClient.shared.getAppleMusicLink(artist: artist, album: album) { link in
                DispatchQueue.main.async(execute: {
                    self.itunesUrl = link
                    self.listenButtonOutlet.isEnabled = true
                    self.listenButtonLabel.textColor = .white
                    self.listenButtonIcon.tintColor = .white
                })
            }
        })
    */}

}
