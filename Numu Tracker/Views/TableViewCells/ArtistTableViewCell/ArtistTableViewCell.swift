//
//  ArtistTableViewCell.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    var artist: APIArtist? {
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

        var recentReleaseDate = "No Releases"
//        if let date = self.artist?.recentReleaseDate {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .long
//            recentReleaseDate = dateFormatter.string(from: date)
//        }

        var percentage: Float = 0
//        if let listened = self.artist?.userData?.listenedReleases, let total = self.artist?.userData?.totalReleases {
//            if total == 0 {
//                percentage = 100
//            } else {
//                percentage = (listened / total) * 100
//            }
//            print(self.artist?.name, listened, total, percentage)
//        }

        self.artistNameLabel.text = self.artist?.name
        self.artistRecentReleaseLabel.text = recentReleaseDate
        self.artistListenPercentageLabel.text = "\(Int(percentage))% Listened"

        self.artistArtImageView.kf.setImage(with: self.artist?.primaryArtUrl, options: [.transition(.fade(0.2))])
    }

    fileprivate func setupViewElements() {
        artistArtActivityIndicator.isHidden = false
        artistArtActivityIndicator.startAnimating()

        artistArtLoadingShadowView.layer.shadowColor = UIColor.black.cgColor
        artistArtLoadingShadowView.layer.shadowOpacity = 0.3
        artistArtLoadingShadowView.layer.shadowOffset = .zero
        artistArtLoadingShadowView.layer.shadowRadius = 5
    }

    public func getEditActions() -> [UITableViewRowAction] {
        let followAction = UITableViewRowAction(style: .normal, title: "Unfollow") { (_, index) in
            print(index)
        }
        followAction.backgroundColor = .background

        return [followAction]
    }

}
