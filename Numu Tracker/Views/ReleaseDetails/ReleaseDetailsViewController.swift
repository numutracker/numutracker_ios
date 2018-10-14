//
//  ReleaseDetailsViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class ReleaseDetailsViewController: UIViewController {

    @IBOutlet weak var releaseDetailsView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }

    func configure(release: ReleaseItem) {
        self.albumArtImageView.layer.shadowColor = UIColor.black.cgColor
        self.albumArtImageView.layer.shadowOpacity = 0.3
        self.albumArtImageView.layer.shadowOffset = .zero
        self.albumArtImageView.layer.shadowRadius = 5
        
        self.albumArtImageView.kf.setImage(
            with: release.thumbUrl,
            options: [.transition(.fade(0.2))])

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != releaseDetailsView {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        releaseDetailsView.layer.cornerRadius = 15
        releaseDetailsView.layer.shadowColor = UIColor.black.cgColor
        releaseDetailsView.layer.shadowOpacity = 0.2
        releaseDetailsView.layer.shadowOffset = CGSize.zero
        releaseDetailsView.layer.shadowRadius = 20
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func animateView() {
        releaseDetailsView.alpha = 0
        self.releaseDetailsView.frame.origin.y += 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.releaseDetailsView.alpha = 1.0
            self.releaseDetailsView.frame.origin.y -= 50
        })
    }

}
