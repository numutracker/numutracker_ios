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

    // @IBOutlet weak var listenSpofityButton: UIButton!
    @IBOutlet weak var listenOnItunesButton: UIButton!
    @IBOutlet weak var listenButtonView: UIView!
    var spotifyUrl: String?
    /* @IBAction func listenOnSpotifyButton(_ sender: Any) {
        if let urlString = self.spotifyUrl {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }*/
    var itunesUrl: String?
    @IBAction func listenOnItunesButtonAction(_ sender: Any) {
        if let urlString = self.itunesUrl {
            UIApplication.shared.open(URL(string: urlString + "&app=music")!)
        }
    }

    // Expanding variables
    class var expandedHeight: CGFloat { get { return 219 } }
    class var defaultHeight: CGFloat  { get { return 136  } }
    var loadedListenLinks = false
    var isObserving = false


    var thumbUrl: NSURL!

    func configure(releaseInfo: ReleaseItem) {
        listenStatus = releaseInfo.listenStatus
        artistName.text = releaseInfo.artistName
        releaseTitle.text = releaseInfo.albumName

        // listenSpofityButton.layer.cornerRadius = 8

        dateLabel.text = releaseInfo.releaseType + " • " + releaseInfo.releaseDate

        thumbUrl = releaseInfo.thumbUrl

        albumArt.layer.shadowColor = UIColor.black.cgColor
        albumArt.layer.shadowOpacity = 0.3
        albumArt.layer.shadowOffset = .zero
        albumArt.layer.shadowRadius = 5
        //albumArt.layer.shadowPath = UIBezierPath(rect: albumArt.bounds).cgPath
        //albumArt.layer.shouldRasterize = true


        readIndicator.layer.shadowColor = UIColor.shadow.cgColor
        readIndicator.layer.shadowOpacity = 0.9
        readIndicator.layer.shadowOffset = .zero
        readIndicator.layer.shadowRadius = 4
        //albumArt.layer.shadowPath = UIBezierPath(rect: listenMarkerView.bounds).cgPath
        readIndicator.layer.shouldRasterize = true

        //print("read",releaseInfo.listenStatus)

        if self.listenStatus == "0" {
            readIndicator.isHidden = false
        } else {
            readIndicator.isHidden = true
        }

    }
    func checkHeight() {
        //listenButtonView.isHidden = (frame.size.height < ReleaseTableViewCell.expandedHeight)
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
        //print("Loading Links..")
        let artist = self.artistName.text
        let album = self.releaseTitle.text
        DispatchQueue.global(qos: .background).async(execute: {
            /* // Find spotify link
            JSONClient.sharedClient.getSpotifyLink(artist: self.artistName.text, album: self.releaseTitle.text) { link in
                DispatchQueue.main.async(execute: {
                    //self.spotifyUrl = link
                    // self.listenSpofityButton.isEnabled = true
                    //print(self.spotifyUrl ?? "No Spotify Link")
                })
            }*/

           NumuClient.shared.getAppleMusicLink(artist: artist, album: album) { link in
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
        self.spotifyUrl = nil
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
