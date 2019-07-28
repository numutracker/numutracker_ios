//
//  SearchYouTubeTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/20/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class SearchDeezerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellButton: NumuModalButton!

    @IBAction func searchDeezer(_ sender: Any) {
        if let urlString = self.searchUrl {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }

    var releaseData: ReleaseItem?
    var searchUrl: String?

    func configure(release: ReleaseItem) {
        self.releaseData = release
        self.cellButton.isEnabled = false
        self.cellLabel.textColor = UIColor.init(white: 1, alpha: 0.1)
        self.cellImage.image = self.cellImage.image?.withRenderingMode(.alwaysTemplate)
        self.cellImage.tintColor = UIColor.init(white: 1, alpha: 0.1)
        self.makeSearchURL()
    }

    func makeSearchURL() {
        if let artist = self.releaseData?.artistName,
            let album = self.releaseData?.albumName {
            if let query = "\(artist) \(album)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.searchUrl = "deezer://www.deezer.com/search/\(query)"
                self.cellButton.isEnabled = true
                self.cellLabel.textColor = .white
                self.cellImage.tintColor = .white
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
