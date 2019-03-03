//
//  ReleaseDetailsViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class ReleaseDetailsViewController: UIViewController, UITableViewDataSource {

    var release: APIRelease?
    var artist: APIArtist?
    var animationDirection: CGFloat = 50.00
    var options: [[String: Any]] = []

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
        self.releaseOptionsTableView.register(
            UINib(nibName: "SearchSoundCloudTableViewCell", bundle: nil),
            forCellReuseIdentifier: "searchSoundCloudCell")
        self.releaseOptionsTableView.register(
            UINib(nibName: "SearchYouTubeTableViewCell", bundle: nil),
            forCellReuseIdentifier: "searchYouTubeCell")
        self.releaseOptionsTableView.dataSource = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReleaseDetailsViewController.dismissView))
        self.tapRecognizerView.addGestureRecognizer(tapGestureRecognizer)
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

    func configure(release: APIRelease, presentingArtist artist: APIArtist?) {
        self.release = release
        self.artist = artist
        self.buildOptions()

        self.albumArtImageView.kf.setImage(
            with: release.primaryArtUrl,
            options: [.transition(.fade(0.2))])

        self.releaseNameLabel.text = release.title
        self.artistNameLabel.text = release.artistNames
        self.releaseMetaLabel.text = release.type + " • " // + release.dateRelease
    }

    func buildOptions() {
        if !defaults.disabledAppleMusic {
            self.options.append(["option": "apple-music"])
        }

        if defaults.enabledSpotify {
            self.options.append(["option": "spotify"])
        }

        if defaults.enabledSoundCloud {
            self.options.append(["option": "soundcloud"])
        }

        if defaults.enabledYouTube {
            self.options.append(["option": "youtube"])
        }

        guard let artists = self.release?.artists else { return }
        for artist in artists {
            if let currentArtistUnwrapped = self.artist, currentArtistUnwrapped.name == artist.name {
                // Do nothing...
            } else {
                self.options.append(["option": "more-releases", "artist": artist])
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
        var optionName = self.options[indexPath.row]["option"] as! String
        switch optionName {
        case "apple-music":
            if let cell = tableView.dequeueReusableCell(
                     withIdentifier: "listenAMCell",
                     for: indexPath) as? ListenAMTableViewCell {
                cell.configure(release: self.release!)
                return cell
            }

        case "more-releases":
            if let cell = tableView.dequeueReusableCell(
                    withIdentifier: "moreReleasesCell",
                    for: indexPath) as? MoreReleasesTableViewCell {
                cell.moreReleasesDelegate = self
                cell.configure(artist: self.options[indexPath.row]["artist"] as! APIArtist)
                return cell
            }

        case "spotify":
            if let cell = tableView.dequeueReusableCell(
                    withIdentifier: "listenSpotifyCell",
                    for: indexPath) as? ListenSpotifyTableViewCell {
                cell.configure(release: self.release!)
                return cell
            }

        case "youtube":
            if let cell = tableView.dequeueReusableCell(
                    withIdentifier: "searchYouTubeCell",
                    for: indexPath) as? SearchYouTubeTableViewCell {
                cell.configure(release: self.release!)
                return cell
            }
        case "soundcloud":
            if let cell = tableView.dequeueReusableCell(
                    withIdentifier: "searchSoundCloudCell",
                    for: indexPath) as? SearchSoundCloudTableViewCell {
                cell.configure(release: self.release!)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

}

extension ReleaseDetailsViewController: MoreReleasesDelegate {
    func showMoreReleases(artist: APIArtist) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let releasesView = storyboard.instantiateViewController(
            withIdentifier: "artistReleasesTableViewControler") as? ArtistReleasesTableViewController else { return }

            releasesView.artist = artist

            self.presentingViewController?.navigationController?.pushViewController(releasesView, animated: true)

            if let tabBar = self.presentingViewController as? UITabBarController,
                let window = tabBar.selectedViewController as? UINavigationController {
                window.pushViewController(releasesView, animated: true)
            }
            self.dismiss(animated: false, completion: nil)
        }
}
