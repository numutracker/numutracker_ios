//
//  ReleaseTableViewCell.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit
import Kingfisher

class ReleaseTableViewCell: UITableViewCell {
    var release: Release? {
        didSet {
            self.setupCell()
        }
    }
    @IBOutlet weak var releaseArtImageView: UIImageView!
    @IBOutlet weak var releaseArtLoadingShadowView: UIView!
    @IBOutlet weak var releaseArtLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var releaseTypeLabel: UILabel!
    @IBOutlet weak var releaseArtistNamesLabel: UILabel!
    @IBOutlet weak var releaseTitleLabel: UILabel!
    @IBOutlet weak var releaseListenMarkerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    fileprivate func updateListenMarkerView() {
        if let userData = self.release?.userData, userData.listened == true {
            self.releaseListenMarkerView.isHidden = true
        } else {
            self.releaseListenMarkerView.isHidden = false
        }
    }

    fileprivate func setupCell() {
        self.setupViewElements()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.string(from: (self.release?.dateRelease)!)

        self.releaseTitleLabel.text = self.release?.title
        let typeLabelText = (self.release?.type)! + " • " + date
        self.releaseArtistNamesLabel.text = self.release?.artistNames
        self.releaseTypeLabel.text = typeLabelText

        self.updateListenMarkerView()

        var artUrl = URL(string: "https://www.numutracker.com/nonly3-1024.png")
        if let releaseArt = self.release?.art {
            artUrl = releaseArt.fullUrl
        } else {
            for artist in self.release!.artists {
                if let artistArt = artist.art {
                    artUrl = artistArt.fullUrl
                }
            }
        }

        self.releaseArtImageView.kf.setImage(
            with: artUrl,
            options: [.transition(.fade(0.2))])

    }

    fileprivate func setupViewElements() {
        releaseArtLoadingIndicatorView.isHidden = false
        releaseArtLoadingIndicatorView.startAnimating()

        releaseArtLoadingShadowView.layer.shadowColor = UIColor.black.cgColor
        releaseArtLoadingShadowView.layer.shadowOpacity = 0.3
        releaseArtLoadingShadowView.layer.shadowOffset = .zero
        releaseArtLoadingShadowView.layer.shadowRadius = 5

        releaseListenMarkerView.layer.shadowColor = UIColor.shadow.cgColor
        releaseListenMarkerView.layer.shadowOpacity = 0.9
        releaseListenMarkerView.layer.shadowOffset = .zero
        releaseListenMarkerView.layer.shadowRadius = 4
        releaseListenMarkerView.layer.shouldRasterize = true
    }

    public func getEditActions() -> [UITableViewRowAction] {
        let listenedActon = UITableViewRowAction(style: .normal, title: "Listened") { (_, index) in

        }
        listenedActon.backgroundColor = .background

        let addOrRemoveAction = UITableViewRowAction(style: .normal, title: "Remove from Library") { (_, index) in
            print(self.release?.title)
        }
        addOrRemoveAction.backgroundColor = .lightBackground

        return [listenedActon, addOrRemoveAction]
    }

}
