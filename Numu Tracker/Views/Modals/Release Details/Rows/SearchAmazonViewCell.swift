//
//  SearchYouTubeTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/20/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class SearchAmazonTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellButton: NumuModalButton!

    @IBAction func searchAmazon(_ sender: Any) {
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
                // I would love to properly link to Amazon Music's iOS app here
                // But unfortunately their app just doesn't support deep links to the search page.
                // So instead we try to link to search in the Amazon app, which still
                // doesn't properly redirect to the Amazon Music app. It really sucks.
                self.searchUrl = "https://www.amazon.com/s?k=\(query)&i=digital-music"
//                self.searchUrl = "amznmp3://search?k=\(query)"
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
