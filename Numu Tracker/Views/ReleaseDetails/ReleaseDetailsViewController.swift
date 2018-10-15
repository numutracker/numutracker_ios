//
//  ReleaseDetailsViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class ReleaseDetailsViewController: UIViewController, UITableViewDataSource {
    
    var releaseData: ReleaseItem?
    
    @IBOutlet weak var releaseMetaLabel: UILabel!
    @IBOutlet weak var releaseNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseDetailsView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var tapRecognizerView: UIView!
    @IBOutlet weak var releaseOptionsTableView: UITableView!
    @IBOutlet weak var releaseOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listenedButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.releaseOptionsTableView.register(UINib(nibName: "ListenAMTableViewCell", bundle: nil), forCellReuseIdentifier: "listenAMCell")
        
        self.releaseOptionsTableView.dataSource = self
        
        self.listenedButton.clipsToBounds = true
        self.listenedButton.backgroundColor = UIColor.background
        self.listenedButton.layer.cornerRadius = 15
        self.listenedButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        super.updateViewConstraints()
        
        self.releaseOptionsHeightConstraint.constant = self.releaseOptionsTableView.contentSize.height
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    func configure(release: ReleaseItem) {
        self.releaseData = release
        self.albumArtImageView.layer.shadowColor = UIColor.black.cgColor
        self.albumArtImageView.layer.shadowOpacity = 0.3
        self.albumArtImageView.layer.shadowOffset = .zero
        self.albumArtImageView.layer.shadowRadius = 5
        
        self.albumArtImageView.kf.setImage(
            with: release.thumbUrl,
            options: [.transition(.fade(0.2))])
        
        self.releaseNameLabel.text = release.albumName
        self.artistNameLabel.text = release.artistName
        self.releaseMetaLabel.text = release.releaseType + " • " + release.releaseDate

    }

    func setupView() {
        releaseDetailsView.layer.cornerRadius = 15
        releaseDetailsView.layer.shadowColor = UIColor.black.cgColor
        releaseDetailsView.layer.shadowOpacity = 0.2
        releaseDetailsView.layer.shadowOffset = CGSize.zero
        releaseDetailsView.layer.shadowRadius = 20
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            releaseDetailsView.backgroundColor = .clear
            
            let detailBlurEffect = UIBlurEffect(style: .dark)
            let detailBlurEffectView = UIVisualEffectView(effect: detailBlurEffect)
            //always fill the view
            detailBlurEffectView.frame = releaseDetailsView.bounds
            detailBlurEffectView.layer.cornerRadius = 15
            detailBlurEffectView.clipsToBounds = true
            detailBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            releaseDetailsView.insertSubview(detailBlurEffectView, at: 0)
            
            self.view.backgroundColor = .clear
            
            let bgBlurEffect = UIBlurEffect(style: .regular)
            let bgBlurEffectView = UIVisualEffectView(effect: bgBlurEffect)
            //always fill the view
            bgBlurEffectView.frame = self.view.bounds
            bgBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.insertSubview(bgBlurEffectView, at: 0)
            
        } else {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReleaseDetailsViewController.dismissView))
        self.tapRecognizerView.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateView() {
        releaseDetailsView.alpha = 0
        self.releaseDetailsView.frame.origin.y += 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.releaseDetailsView.alpha = 1.0
            self.releaseDetailsView.frame.origin.y -= 50
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Loading row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "listenAMCell", for: indexPath) as! ListenAMTableViewCell
        cell.configure(release: self.releaseData!)
        cell.contentView.frame.size.width = self.view.frame.size.width
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

}
