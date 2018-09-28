//
//  ArtistReleaseTableViewCell.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class ArtistReleaseTableViewCell: UITableViewCell {

    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var albumArtActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var readIndicator: UIView!
    @IBOutlet weak var releaseTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var artistName: UILabel!

    var listenStatus: String!

    @IBOutlet weak var listenOnItunesButton: UIButton!
    @IBOutlet weak var listenButtonView: UIView!

    var itunesUrl: String?
    @IBAction func listenOnItunesButtonAction(_ sender: Any) {
        if let urlString = self.itunesUrl {
            UIApplication.shared.open(URL(string: urlString + "&app=music")!)
        }
    }

    // Expanding variables
    class var expandedHeight: CGFloat { return 219 }
    class var defaultHeight: CGFloat { return 136 }
    var loadedListenLinks = false
    var isObserving = false

    var thumbUrl: URL!

    func configure(releaseInfo: ReleaseItem) {
        listenStatus = releaseInfo.listenStatus
        artistName.text = releaseInfo.artistName
        releaseTitle.text = releaseInfo.albumName

        dateLabel.text = releaseInfo.releaseType + " • " + releaseInfo.releaseDate

        thumbUrl = releaseInfo.thumbUrl

        albumArt.layer.shadowColor = UIColor.black.cgColor
        albumArt.layer.shadowOpacity = 0.3
        albumArt.layer.shadowOffset = .zero
        albumArt.layer.shadowRadius = 5

        readIndicator.layer.shadowColor = UIColor.shadow.cgColor
        readIndicator.layer.shadowOpacity = 0.9
        readIndicator.layer.shadowOffset = .zero
        readIndicator.layer.shadowRadius = 4
        readIndicator.layer.shouldRasterize = true

        if self.listenStatus == "0" {
            readIndicator.isHidden = false
        } else {
            readIndicator.isHidden = true
        }

    }

    func checkHeight() {
        if frame.size.height < ArtistReleaseTableViewCell.expandedHeight {
            if loadedListenLinks {
                self.removeListenLinks()
            }
        } else {
            if !loadedListenLinks {
                self.loadListenLinks()
            }
        }
    }

    func loadListenLinks() {
        let artist = self.artistName.text
        let album = self.releaseTitle.text
        DispatchQueue.global(qos: .background).async(execute: {
           NumuClient.shared.getAppleMusicLink(artist: artist, album: album) { link in
                DispatchQueue.main.async(execute: {
                    self.itunesUrl = link
                    self.listenOnItunesButton.isEnabled = true
                })
            }
        })
        self.loadedListenLinks = true
    }

    func removeListenLinks() {
        self.loadedListenLinks = false
        self.itunesUrl = nil
        self.listenOnItunesButton.isEnabled = false
    }

    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [.new, .initial], context: nil)
            isObserving = true
        }
    }

    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
