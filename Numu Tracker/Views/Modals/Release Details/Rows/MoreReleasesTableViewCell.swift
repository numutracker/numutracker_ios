//
//  MoreReleasesTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/16/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

protocol MoreReleasesDelegate {
    func showMoreReleases(artist: Artist)
}

class MoreReleasesTableViewCell: UITableViewCell {
    var moreReleasesDelegate: MoreReleasesDelegate!

    var artist: Artist?

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var buttonOutlet: NumuModalButton!
    @IBAction func buttonAction(_ sender: Any) {
        if let artist = self.artist {
            moreReleasesDelegate.showMoreReleases(artist: artist)
        }
    }

    func configure(artist: Artist) {
        self.artist = artist
        self.cellLabel.textColor = .white
        if let artistName = self.artist?.name {
            self.cellLabel.text = "More releases by \(artistName)"
        }
        self.cellIcon.image = self.cellIcon.image?.withRenderingMode(.alwaysTemplate)
        self.cellIcon.tintColor = .white
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
