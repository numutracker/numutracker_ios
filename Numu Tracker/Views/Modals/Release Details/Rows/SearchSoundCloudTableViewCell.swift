//
//  SearchSoundCloudTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/20/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class SearchSoundCloudTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellButton: NumuModalButton!

    var release: NumuAPIRelease?
    var searchUrl: String?

    @IBAction func searchSoundCloud(_ sender: Any) {
        if let urlString = self.searchUrl {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }

    func configure(release: NumuAPIRelease) {
        self.release = release
        self.cellButton.isEnabled = false
        self.cellLabel.textColor = UIColor.init(white: 1, alpha: 0.1)
        self.cellIcon.image = self.cellIcon.image?.withRenderingMode(.alwaysTemplate)
        self.cellIcon.tintColor = UIColor.init(white: 1, alpha: 0.1)
        self.makeSearchURL()
    }

    func makeSearchURL() {
        if let artist = self.release?.artistNames,
            let album = self.release?.title {
            if let query = "\(artist) \(album)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.searchUrl = "https://soundcloud.com/search?q=\(query)"
                self.cellButton.isEnabled = true
                self.cellLabel.textColor = .white
                self.cellIcon.tintColor = .white
            }
        }
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
