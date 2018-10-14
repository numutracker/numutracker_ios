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
        
        self.selectionStyle = .default
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1.0)
        self.selectedBackgroundView = bgColorView

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let bgColor = readIndicator.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            readIndicator.backgroundColor = bgColor
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let bgColor = readIndicator.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            readIndicator.backgroundColor = bgColor
        }
    }

}
