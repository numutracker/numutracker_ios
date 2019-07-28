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

    @IBOutlet weak var artIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listenedIndicatorView: UIView!
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseNameLabel: UILabel!
    var thumbUrl: URL!
    var listenState: String! {
        didSet {
            listenedIndicatorView.isHidden = listenState == "1"
        }
    }

    var releaseId: String = "0"

    var artistItem: ArtistItem?

    func configure(releaseInfo: ReleaseItem) {

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

        self.selectionStyle = .default
        let bgColorView = UIView()
        bgColorView.backgroundColor = .selectedCell
        self.selectedBackgroundView = bgColorView

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let bgColor = listenedIndicatorView.backgroundColor
        super.setSelected(selected, animated: animated)

        if selected {
            listenedIndicatorView.backgroundColor = bgColor
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let bgColor = listenedIndicatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            listenedIndicatorView.backgroundColor = bgColor
        }
    }

}
