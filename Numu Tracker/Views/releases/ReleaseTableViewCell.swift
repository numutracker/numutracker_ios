//
//  ReleaseTableViewCell.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/29/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class ReleaseTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMoreReleasesButton: UIButton!
    // @IBOutlet weak var listenSpofityButton: UIButton!
    @IBOutlet weak var listenButtonView: UIView!
    @IBOutlet weak var artIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listenedIndicatorView: UIView!
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseNameLabel: UILabel!
    var thumbUrl: NSURL!
    var listenState: String! {
        didSet {
            listenedIndicatorView.isHidden = listenState == "1"
        }
    }
    var spotifyUrl: String?
    @IBAction func listenOnSpotifyButton(_ sender: Any) {
        if let urlString = self.spotifyUrl {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }
    var itunesUrl: String?
    @IBOutlet weak var listenOnItunesButton: UIButton!
    @IBAction func listenOnItunesButtonAction(_ sender: Any) {
        if let urlString = self.itunesUrl {
            UIApplication.shared.open(URL(string: urlString + "&app=music")!)
        }
    }
    var releaseId: String = "0"

    // Expanding variables
    class var expandedHeight: CGFloat { return 247 }
    class var defaultHeight: CGFloat { return 136 }
    var loadedListenLinks = false
    var isObserving = false

    var artistItem: ArtistItem?

    func configure(releaseInfo: ReleaseItem) {

        viewMoreReleasesButton.setTitle("View other releases by " + releaseInfo.artistName, for: .normal)

        artistLabel.text = releaseInfo.artistName
        releaseNameLabel.text = releaseInfo.albumName

        releaseId = releaseInfo.releaseId

        metaLabel.text = releaseInfo.releaseType + " • " + releaseInfo.releaseDate

        thumbUrl = releaseInfo.thumbUrl

        artImageView.layer.shadowColor = UIColor.black.cgColor
        artImageView.layer.shadowOpacity = 0.3
        artImageView.layer.shadowOffset = .zero
        artImageView.layer.shadowRadius = 5

        listenedIndicatorView.layer.shadowColor = UIColor.shadow.cgColor
        listenedIndicatorView.layer.shadowOpacity = 0.9
        listenedIndicatorView.layer.shadowOffset = .zero
        listenedIndicatorView.layer.shadowRadius = 4
        listenedIndicatorView.layer.shouldRasterize = true

        if releaseInfo.listenStatus == "0" {
            listenState = "0"
        } else {
            listenState = "1"
        }

    }

func checkHeight() {
    if frame.size.height < ReleaseTableViewCell.expandedHeight {
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
        let artist = self.artistLabel.text
        let album = self.releaseNameLabel.text
        Answers.logCustomEvent(withName: "Loaded L Links", customAttributes: ["Release ID": self.releaseId])
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
