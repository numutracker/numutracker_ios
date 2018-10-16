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
    var animationDirection: CGFloat = 50.00
    
    @IBOutlet weak var releaseMetaLabel: UILabel!
    @IBOutlet weak var releaseNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseDetailsView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var tapRecognizerView: UIView!
    @IBOutlet weak var releaseOptionsTableView: UITableView!
    @IBOutlet weak var releaseOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listenedButton: UIButton!
    @IBOutlet weak var releaseDetailsContainer: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.releaseOptionsTableView.register(
            UINib(nibName: "ListenAMTableViewCell", bundle: nil),
            forCellReuseIdentifier: "listenAMCell")
        self.releaseOptionsTableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReleaseDetailsViewController.dismissView))
        self.tapRecognizerView.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        super.updateViewConstraints()
        self.releaseOptionsHeightConstraint.constant = self.releaseOptionsTableView.contentSize.height
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modalPresentationCapturesStatusBarAppearance = true
        setupView()
        animateView()
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func configure(release: ReleaseItem) {
        self.releaseData = release
        
        self.albumArtImageView.kf.setImage(
            with: release.thumbUrl,
            options: [.transition(.fade(0.2))])
        
        self.releaseNameLabel.text = release.albumName
        self.artistNameLabel.text = release.artistName
        self.releaseMetaLabel.text = release.releaseType + " • " + release.releaseDate
    }
    
    // MARK: - Appearance

    func setupView() {
        self.albumArtImageView.layer.shadowColor = UIColor.black.cgColor
        self.albumArtImageView.layer.shadowOpacity = 0.3
        self.albumArtImageView.layer.shadowOffset = .zero
        self.albumArtImageView.layer.shadowRadius = 5
        
        self.listenedButton.clipsToBounds = true
        self.listenedButton.backgroundColor = UIColor.background
        self.listenedButton.layer.cornerRadius = 15
        self.listenedButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        releaseDetailsView.layer.cornerRadius = 15
        releaseDetailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            releaseDetailsView.backgroundColor = .clear
            let detailBlurEffect = UIBlurEffect(style: .dark)
            let detailBlurEffectView = UIVisualEffectView(effect: detailBlurEffect)
            detailBlurEffectView.frame = releaseDetailsView.bounds
            detailBlurEffectView.layer.cornerRadius = 15
            detailBlurEffectView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            detailBlurEffectView.clipsToBounds = true
            detailBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            releaseDetailsView.insertSubview(detailBlurEffectView, at: 0)
            
            self.view.backgroundColor = .clear
            let bgBlurEffect = UIBlurEffect(style: .regular)
            let bgBlurEffectView = UIVisualEffectView(effect: bgBlurEffect)
            bgBlurEffectView.frame = self.view.bounds
            bgBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.insertSubview(bgBlurEffectView, at: 0)
            
        } else {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    func animateView() {
        var offset: CGFloat = 0
        
        switch self.animationDirection {
        case 0 ... 20:
            offset = -200
        case 20 ... 40:
            offset = -50
        case 60 ... 75:
            offset = 50
        case 75 ... 100:
            offset = 200
        default:
            offset = 0
        }

        releaseDetailsContainer.alpha = 0
        self.releaseDetailsContainer.frame.origin.y += offset
        self.releaseDetailsContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.releaseDetailsContainer.alpha = 1.0
            self.releaseDetailsContainer.frame.origin.y -= offset
            self.releaseDetailsContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Loading row")
        let cell = tableView.dequeueReusableCell(
             withIdentifier: "listenAMCell",
             for: indexPath) as! ListenAMTableViewCell
        cell.configure(release: self.releaseData!)
        return cell
    }

}
