//
//  ArtistTableViewCell.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    var artist: Artist? {
        didSet {
            self.setupCell()
        }
    }

    @IBOutlet weak var artistArtImageView: UIImageView!
    @IBOutlet weak var artistArtLoadingShadowView: UIView!
    @IBOutlet weak var artistArtActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistRecentReleaseLabel: UILabel!
    @IBOutlet weak var artistListenPercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    fileprivate func setupCell() {
        self.setupViewElements()

        self.artistNameLabel.text = self.artist?.name

        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let artistArt = self.artist?.art {
            artUrl = artistArt.fullUrl
        }

        self.artistArtImageView.kf.setImage(with: artUrl, options: [.transition(.fade(0.2))])
    }

    fileprivate func setupViewElements() {
        artistArtActivityIndicator.isHidden = false
        artistArtActivityIndicator.startAnimating()

        artistArtLoadingShadowView.layer.shadowColor = UIColor.black.cgColor
        artistArtLoadingShadowView.layer.shadowOpacity = 0.3
        artistArtLoadingShadowView.layer.shadowOffset = .zero
        artistArtLoadingShadowView.layer.shadowRadius = 5

    }

}
