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

    var selectedIndexPath : IndexPath?
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
            // Get artist item...
            self.navigationController?.navigationBar.tintColor = .white
            let selectedArtist: String = artistId
            self.title = artistName
            self.tableView.tableFooterView = footerView
            DispatchQueue.global(qos: .background).async(execute: {
                SearchClient.sharedClient.getArtistReleases(artist: selectedArtist) {[weak self](releases) in
                    self?.releases = releases
                }

                SearchClient.sharedClient.getSingleArtistItem(search: selectedArtist) {[weak self](artists) in
                    self?.artistItem = artists
                }

                DispatchQueue.main.async(execute: {
                    if !defaults.bool(forKey: "logged") {
                        self.navigationItem.rightBarButtonItem?.title = "Follow"
                    } else {
                        let title = self.artistItem[0].followStatus == "1" ? "Unfollow" : "Follow"
                        self.navigationItem.rightBarButtonItem?.title = title
                    }
                    self.tableView.reloadData()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    self.tableView.tableFooterView = UIView()
                    if self.releases.isEmpty {
                        self.tableView.tableFooterView = self.noResultsView
                    }
                })
            })

            Answers.logCustomEvent(withName: "Artist Screen", customAttributes: ["Artist ID":selectedArtist])

        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @objc func addTapped() {
            if let artistId = self.artistId {
                if defaults.bool(forKey: "logged") {
                    DispatchQueue.global(qos: .background).async(execute: {
                        let success = SearchClient.sharedClient.unfollowArtist(artistMbid: artistId)
                        DispatchQueue.main.async(execute: {
                            if success == "1" {
                               self.navigationItem.rightBarButtonItem?.title = "Follow"
                                Answers.logCustomEvent(withName: "Unfol Bar", customAttributes: ["Artist ID":artistId])
                            } else if success == "2" {
                                self.navigationItem.rightBarButtonItem?.title = "Unfollow"
                                Answers.logCustomEvent(withName: "Follo Bar", customAttributes: ["Artist ID":artistId])
                            }
                        })
                    })
                } else {
                    if UIDevice().screenType == .iPhone4 {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPromptSmall") as! UINavigationController
                        DispatchQueue.main.async {
                            self.present(loginViewController, animated: true, completion: nil)
                        }
                    } else {
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return releases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistAlbumCell", for: indexPath) as! ArtistReleaseTableViewCell

        // Configure the cell...
        let releaseInfo = releases[indexPath.row]
        cell.configure(releaseInfo: releaseInfo)
        cell.albumArtActivityIndicator.startAnimating()
        cell.thumbUrl = releaseInfo.thumbUrl // For recycled cells' late image loads.
        if let image = releaseInfo.thumbUrl.cachedImage {
            // Cached: set immediately.
            cell.albumArt.image = image
            cell.albumArt.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            cell.albumArt.alpha = 0
            releaseInfo.thumbUrl.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell.thumbUrl == releaseInfo.thumbUrl {
                    cell.albumArt.image = image
                    UIView.animate(withDuration: 0.3) {
                        cell.albumArt.alpha = 1
                    }
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let releaseInfo = self.releases[indexPath.row]

        let listened = UITableViewRowAction(style: .normal, title: "Listened") { action, index in
            if !defaults.bool(forKey: "logged") {
                if UIDevice().screenType == .iPhone4 {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPromptSmall") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                } else {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.global(qos: .background).async(execute: {
                    let success = releaseInfo.toggleListenStatus()
                    DispatchQueue.main.async(execute: {
                        if success == "1" {
                            // remove or add unread marker back in
                            let cell = self.tableView.cellForRow(at: indexPath) as! ArtistReleaseTableViewCell
                            if cell.readIndicator.isHidden && releaseInfo.listenStatus != "2" {
                                cell.readIndicator.isHidden = false
                                cell.listenStatus = "0"
                                self.releases[indexPath.row].listenStatus = "0"
                                Answers.logCustomEvent(withName: "Unlistened", customAttributes: ["Release ID":releaseInfo.releaseId])
                            } else {
                                cell.readIndicator.isHidden = true
                                cell.listenStatus = "1"
                                self.releases[indexPath.row].listenStatus = "1"
                                Answers.logCustomEvent(withName: "Listened", customAttributes: ["Release ID":releaseInfo.releaseId])
                            }
                            tableView.setEditing(false, animated: true)
                        }
                    })
                })
            }

        }

        if releaseInfo.listenStatus == "1" {
            listened.title = "Didn't Listen"
        }
        listened.backgroundColor = .bg

        return [listened]

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }

        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.beginUpdates()
            //tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
            tableView.endUpdates()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ArtistReleaseTableViewCell).watchFrameChanges()
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ArtistReleaseTableViewCell).ignoreFrameChanges()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [ArtistReleaseTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for cell in tableView.visibleCells as! [ArtistReleaseTableViewCell] {
            cell.watchFrameChanges()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return ArtistReleaseTableViewCell.expandedHeight
        } else {
            return ArtistReleaseTableViewCell.defaultHeight
        }
    }
}
