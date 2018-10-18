//
//  MoreReleasesTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/16/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

protocol MoreReleasesDelegate {
    func showMoreReleases(artistId: String)
}

class MoreReleasesTableViewCell: UITableViewCell {
    
    var moreReleasesDelegate: MoreReleasesDelegate!
    
    var releaseData: ReleaseItem?
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        if let artistId = self.releaseData?.artistId {
            moreReleasesDelegate.showMoreReleases(artistId: artistId)
        }
    }
    
    func configure(release: ReleaseItem) {
        self.releaseData = release
        self.cellLabel.textColor = .white
        if let artistName = self.releaseData?.artistName {
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
