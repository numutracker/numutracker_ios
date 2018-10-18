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
    var options: [String] = []
    
    @IBOutlet weak var releaseMetaLabel: UILabel!
    @IBOutlet weak var releaseNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseDetailsView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var tapRecognizerView: UIView!
    @IBOutlet weak var releaseOptionsTableView: UITableView!
    @IBOutlet weak var releaseOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var releaseDetailsContainer: UIView!

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildOptions()
        self.releaseOptionsTableView.rowHeight = 54
        self.releaseOptionsTableView.register(
            UINib(nibName: "ListenAMTableViewCell", bundle: nil),
            forCellReuseIdentifier: "listenAMCell")
        self.releaseOptionsTableView.register(
            UINib(nibName: "MoreReleasesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "moreReleasesCell")
        self.releaseOptionsTableView.register(
            UINib(nibName: "ListenSpotifyTableViewCell", bundle: nil),
            forCellReuseIdentifier: "listenSpotifyCell")
        self.releaseOptionsTableView.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReleaseDetailsViewController.dismissView))
        self.tapRecognizerView.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.releaseOptionsHeightConstraint.constant =
            self.releaseOptionsTableView.rowHeight * CGFloat(self.options.count)
        super.updateViewConstraints()
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
    
    func buildOptions() {
        if true {
            self.options.append("apple-music")
        }
        
        if true {
            self.options.append("spotify")
        }
        
        if let tabBar = self.presentingViewController as? UITabBarController,
            let window = tabBar.selectedViewController as? UINavigationController,
            let viewController = window.visibleViewController {
            if !(viewController is ArtistReleasesTableViewController) {
                self.options.append("more-releases")
            }
        }

    }
    
    // MARK: - Appearance

    func setupView() {
        self.albumArtImageView.layer.shadowColor = UIColor.black.cgColor
        self.albumArtImageView.layer.shadowOpacity = 0.3
        self.albumArtImageView.layer.shadowOffset = .zero
        self.albumArtImageView.layer.shadowRadius = 5
        
        releaseDetailsView.layer.cornerRadius = 15
        self.releaseOptionsTableView.layer.cornerRadius = 15
        self.releaseOptionsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        if !UIAccessibility.isReduceTransparencyEnabled {
            releaseDetailsView.backgroundColor = .clear
            let detailBlurEffect = UIBlurEffect(style: .dark)
            let detailBlurEffectView = UIVisualEffectView(effect: detailBlurEffect)
            detailBlurEffectView.frame = releaseDetailsView.bounds
            detailBlurEffectView.layer.cornerRadius = 15
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
        let originalPosition = self.releaseDetailsContainer.center
        releaseDetailsContainer.alpha = 0
        var newPosition = originalPosition
        newPosition.y = self.animationDirection

        self.releaseDetailsContainer.center = newPosition
        self.releaseDetailsContainer.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.releaseDetailsContainer.alpha = 1.0
            self.releaseDetailsContainer.center = originalPosition
            self.releaseDetailsContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.options[indexPath.row] {
        case "apple-music":
            let cell = tableView.dequeueReusableCell(
                 withIdentifier: "listenAMCell",
                 for: indexPath) as! ListenAMTableViewCell
            cell.configure(release: self.releaseData!)
            return cell

        case "more-releases":
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "moreReleasesCell",
                for: indexPath) as! MoreReleasesTableViewCell
            cell.moreReleasesDelegate = self
            cell.configure(release: self.releaseData!)
            return cell

        case "spotify":
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "listenSpotifyCell",
                for: indexPath) as! ListenSpotifyTableViewCell
            return cell

        case "youtube":
            break
        case "soundcloud":
            break
        default:
            break
        }
        return UITableViewCell()
    }

}

extension ReleaseDetailsViewController: MoreReleasesDelegate {
    func showMoreReleases(artistId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let releasesView = storyboard.instantiateViewController(
            withIdentifier: "artistReleasesController") as! ArtistReleasesTableViewController
        releasesView.artistId = artistId

        self.presentingViewController?.navigationController?.pushViewController(releasesView, animated: true)
        
        if let tabBar = self.presentingViewController as? UITabBarController,
            let window = tabBar.selectedViewController as? UINavigationController {
            window.pushViewController(releasesView, animated: true)
        }
        self.dismiss(animated: false, completion: nil)
    }
}
