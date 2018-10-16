//
//  ListenAMTableViewCell.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/14/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class ListenAMTableViewCell: UITableViewCell {
    
    var releaseData: ReleaseItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("Print from table view cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(release: ReleaseItem) {
        self.releaseData = release
        self.listenButtonOutlet.isEnabled = false
        self.listenButtonLabel.textColor = UIColor.init(white: 1, alpha: 0.1)
        self.listenButtonIcon.image = self.listenButtonIcon.image?.withRenderingMode(.alwaysTemplate)
        self.listenButtonIcon.tintColor = UIColor.init(white: 1, alpha: 0.1)
        self.loadListenLinks()
    }
    
    @IBOutlet weak var listenButtonOutlet: UIButton!
    var itunesUrl: String?
    @IBAction func listenButton(_ sender: Any) {
        print("listen on am...")
        if let urlString = self.itunesUrl {
            UIApplication.shared.open(URL(string: urlString + "&app=music")!)
        }
    }
    @IBOutlet weak var listenButtonLabel: UILabel!
    @IBOutlet weak var listenButtonIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadListenLinks() {
        let artist = self.releaseData?.artistName
        let album = self.releaseData?.albumName
        DispatchQueue.global(qos: .background).async(execute: {
            NumuClient.shared.getAppleMusicLink(artist: artist, album: album) { link in
                DispatchQueue.main.async(execute: {
                    self.itunesUrl = link
                    self.listenButtonOutlet.isEnabled = true
                    self.listenButtonLabel.textColor = .white
                    self.listenButtonIcon.tintColor = .white
                })
            }
        })
    }

}
