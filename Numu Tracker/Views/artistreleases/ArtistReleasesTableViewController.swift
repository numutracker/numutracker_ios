//
//  ArtistReleasesTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/15/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class ArtistReleasesTableViewController: UITableViewController {

    var selectedIndexPath: IndexPath?
    var releases: [ReleaseItem] = []
    var artistId: String?
    var artistName: String?
    var artistItem: [ArtistItem] = []

    @IBOutlet var footerView: UIView!
    @IBOutlet var noResultsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let add = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addTapped))

        navigationItem.rightBarButtonItem = add

        if let artistId = self.artistId {

            self.navigationController?.navigationBar.tintColor = .white
            let selectedArtist: String = artistId
            self.title = artistName
            self.tableView.tableFooterView = footerView

            NumuClient.shared.getArtist(search: selectedArtist) {[weak self](artists) in
                self?.artistItem = artists
                NumuClient.shared.getArtistReleases(artist: selectedArtist) {[weak self](releases) in
                    self?.releases = releases
                    DispatchQueue.main.async(execute: {
                        if !defaults.logged {
                            self?.navigationItem.rightBarButtonItem?.title = "Follow"
                        } else {
                            let title = self?.artistItem[0].followStatus == "1" ? "Remove" : "Follow"
                            self?.navigationItem.rightBarButtonItem?.title = title
                        }
                        self?.tableView.reloadData()
                        self?.tableView.beginUpdates()
                        self?.tableView.endUpdates()
                        self?.tableView.tableFooterView = UIView()
                        if self?.releases.isEmpty ?? true {
                            self?.tableView.tableFooterView = self?.noResultsView
                        }
                    })
                }
            }
            Answers.logCustomEvent(withName: "Artist Screen", customAttributes: ["Artist ID": selectedArtist])
        }

    }

    @objc func addTapped() {
        if let artistId = self.artistId {
            if defaults.logged {
                NumuClient.shared.toggleFollow(artistMbid: artistId) { (success) in
                    DispatchQueue.main.async(execute: {
                        if success == "1" {
                           self.navigationItem.rightBarButtonItem?.title = "Follow"
                            Answers.logCustomEvent(withName: "Unfol Bar", customAttributes: ["Artist ID": artistId])
                        } else if success == "2" {
                            self.navigationItem.rightBarButtonItem?.title = "Remove"
                            Answers.logCustomEvent(withName: "Follo Bar", customAttributes: ["Artist ID": artistId])
                        }
                    })
                }
            } else {
                if let loginViewController = self.storyboard?.instantiateViewController(
                        withIdentifier: "LogRegPrompt") as? UINavigationController {
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return releases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "artistAlbumCell",
            for: indexPath) as? ArtistReleaseTableViewCell else {
                return UITableViewCell()
        }

        // Configure the cell...
        let releaseInfo = releases[indexPath.row]
        cell.configure(releaseInfo: releaseInfo)
        cell.albumArtActivityIndicator.startAnimating()
        cell.thumbUrl = releaseInfo.thumbUrl // For recycled cells' late image loads.

        cell.albumArt.kf.setImage(
            with: cell.thumbUrl,
            options: [.transition(.fade(0.2))])

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let releaseInfo = self.releases[indexPath.row]

        let listened = UITableViewRowAction(style: .normal, title: "Listened") { _, index in
            if !defaults.logged {
                if let loginViewController = self.storyboard?.instantiateViewController(
                        withIdentifier: "LogRegPrompt") as? UINavigationController {
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                } else {
                    // Display error message?
                }
            } else {
                releaseInfo.toggleListenStatus { (success) in
                    DispatchQueue.main.async(execute: {
                        if success == "1" {
                            // remove or add unread marker back in
                            if let cell = self.tableView.cellForRow(at: index) as? ArtistReleaseTableViewCell {
                                if cell.readIndicator.isHidden && releaseInfo.listenStatus != "2" {
                                    cell.readIndicator.isHidden = false
                                    cell.listenStatus = "0"
                                    self.releases[index.row].listenStatus = "0"
                                    Answers.logCustomEvent(
                                        withName: "Unlistened", customAttributes: ["Release ID": releaseInfo.releaseId])
                                } else {
                                    cell.readIndicator.isHidden = true
                                    cell.listenStatus = "1"
                                    self.releases[index.row].listenStatus = "1"
                                    Answers.logCustomEvent(
                                        withName: "Listened", customAttributes: ["Release ID": releaseInfo.releaseId])
                                }
                                tableView.setEditing(false, animated: true)
                            }
                        }
                    })
                }
            }

        }

        if releaseInfo.listenStatus == "1" {
            listened.title = "Didn't Listen"
        }
        listened.backgroundColor = .background

        return [listened]

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let releaseDetails = ReleaseDetailsViewController()
        let cellPosition = tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview)
        releaseDetails.animationDirection = cellPosition.midY
        releaseDetails.providesPresentationContextTransitionStyle = true
        releaseDetails.definesPresentationContext = true
        releaseDetails.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        releaseDetails.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        releaseDetails.modalPresentationCapturesStatusBarAppearance = true
        if let appDelegate = UIApplication.shared.delegate,
            let appWindow = appDelegate.window!,
            let rootViewController = appWindow.rootViewController {
            rootViewController.present(releaseDetails, animated: true, completion: nil)
            releaseDetails.configure(release: self.releases[indexPath.row])
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
