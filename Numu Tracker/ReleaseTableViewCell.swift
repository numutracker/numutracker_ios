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
    class var expandedHeight: CGFloat { get { return 247 } }
    class var defaultHeight: CGFloat  { get { return 136  } }
    var loadedListenLinks = false
    var isObserving = false

    var artistItem: ArtistItem?

    func configure(releaseInfo: ReleaseItem) {

        // listenSpofityButton.layer.cornerRadius = 8

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
        //artImageView.layer.shouldRasterize = true


        listenedIndicatorView.layer.shadowColor = UIColor(red: (28/255), green: (202/255), blue: (241/255), alpha: 1).cgColor
        listenedIndicatorView.layer.shadowOpacity = 0.9
        listenedIndicatorView.layer.shadowOffset = .zero
        listenedIndicatorView.layer.shadowRadius = 4
        listenedIndicatorView.layer.shouldRasterize = true

        if (releaseInfo.listenStatus == "0") {
            listenState = "0"
        } else {
            listenState = "1"
        }


    }

func checkHeight() {
    //listenButtonView.isHidden = (frame.size.height < ReleaseTableViewCell.expandedHeight)
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
        //print("Loading Links..")
        let artist = self.artistLabel.text
        let album = self.releaseNameLabel.text
        Answers.logCustomEvent(withName: "Loaded L Links", customAttributes: ["Release ID":self.releaseId])
        DispatchQueue.global(qos: .background).async(execute: {
            /* Find spotify link
            JSONClient.sharedClient.getSpotifyLink(artist: self.artistLabel.text, album: self.releaseNameLabel.text) { link in
                DispatchQueue.main.async(execute: {
                    self.spotifyUrl = link
                    self.listenSpofityButton.isEnabled = true
                    print(self.spotifyUrl ?? "No Spotify Link")
                })
            }
             */

            JSONClient.sharedClient.getAppleMusicLink(artist: artist, album: album) { link in
                DispatchQueue.main.async(execute: {
                    self.itunesUrl = link
                    self.listenOnItunesButton.isEnabled = true
                    //print(self.itunesUrl ?? "No AM Link")
                })
            }

        })

        self.loadedListenLinks = true
    }

    func removeListenLinks() {
        self.loadedListenLinks = false
        //self.spotifyUrl = nil
        self.itunesUrl = nil
        self.listenOnItunesButton.isEnabled = false
        //self.listenSpofityButton.isEnabled = false
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }


  }
