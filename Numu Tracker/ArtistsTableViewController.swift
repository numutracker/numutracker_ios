//
//  ArtistsTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/15/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class ArtistsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var artists: [ArtistItem] = []
    var sortMethod: String = "date"
    var screenType: String = "yours"
    var lastSelectedArtistId: String = ""
    var lastSelectedArtistName: String = ""

    @IBOutlet var noResultsView: UIView!
    @IBOutlet var noSearchResultsView: UIView!

    var artist: ArtistItem?

    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet var footerView: UIView!

    @IBAction func showSortOptions(_ sender: Any) {

        let optionMenu = UIAlertController(title: "Sort Artists", message: nil, preferredStyle: .actionSheet)

        // 2
        let sortAlpha = UIAlertAction(title: "By Name", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.tableView.tableFooterView = self.footerView
            self.sortMethod = "name"
            self.actOnImportNotification()
        })
        let sortDate = UIAlertAction(title: "By Recent Release", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.tableView.tableFooterView = self.footerView
            self.sortMethod = "date"
            self.actOnImportNotification()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert: UIAlertAction) -> Void in

        }

        // 4
        optionMenu.addAction(sortAlpha)
        optionMenu.addAction(sortDate)
        optionMenu.addAction(cancelAction)

        // colors?
        let subview1 = optionMenu.view.subviews.first! as UIView
        let subview2 = subview1.subviews.first! as UIView
        let view = subview2.subviews.first! as UIView

        subview1.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        subview1.layer.cornerRadius = 10.0
        view.layer.cornerRadius = 10.0

        optionMenu.view.tintColor = .white

        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Artists"
        tableView.tableFooterView = footerView
        tableView.backgroundView = UIView()
        tableView.keyboardDismissMode = .onDrag
        searchController.searchBar.placeholder = "Search for more artists"
        searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.keyboardType = .alphabet
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.backgroundColor = .black
        searchController.searchBar.tintColor = .white
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        //self.definesPresentationContext = true

        // Get list of artists...

        DispatchQueue.global(qos: .background).async(execute: {
            SearchClient.sharedClient.getUserArtists(sortBy: self.sortMethod) {[weak self](artists) in
                self?.artists = artists
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                self.tableView.tableFooterView = UIView()
                if self.artists.isEmpty {
                    self.tableView.tableFooterView = self.noResultsView
                }
            })
        })

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actOnImportNotification),
                                               name: .UpdatedArtists,
                                               object: nil)

        self.tableView.addSubview(self.artistRefreshControl)

        Answers.logCustomEvent(withName: "Your Artists View", customAttributes: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }

    @objc func actOnImportNotification() {
        DispatchQueue.global(qos: .background).async(execute: {
            SearchClient.sharedClient.getUserArtists(sortBy: self.sortMethod) {[weak self](artists) in
                self?.artists = artists
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.tableView.beginUpdates()
                sleep(1)
                self.tableView.endUpdates()
                //self.tableView.setContentOffset(CGPoint(x:0, y:0-self.tableView.contentInset.top), animated: false)
                self.artistRefreshControl.endRefreshing()
                self.tableView.tableFooterView = UIView()
                if self.artists.isEmpty {
                    self.tableView.tableFooterView = self.noResultsView
                }
                self.searchController.searchBar.text = ""
                self.searchController.searchBar.isHidden = false
            })
        })

    }


    lazy var artistRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //print("Refresh")
        self.artists.removeAll()
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        self.searchController.searchBar.isHidden = true
        self.actOnImportNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /* if (!defaults.bool(forKey: "logged")) {
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
            DispatchQueue.main.async {
                self.present(loginViewController, animated: true, completion: nil)
            }
        } */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return artists.count

    }

    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 1)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.artists.removeAll()
        self.tableView.reloadData()
        self.tableView.tableFooterView = footerView
        self.actOnImportNotification()
        self.title = "Your Artists"
    }

    @objc func reload() {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, searchText.count > 2 {
            self.title = "Artist Search"
            self.artists.removeAll()
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
            DispatchQueue.global(qos: .background).async(execute: {
                SearchClient.sharedClient.getArtistSearch(search: searchText) {[weak self](artists) in
                    self?.artists = artists
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    self.tableView.tableFooterView = UIView()
                    if self.artists.isEmpty {
                        self.tableView.tableFooterView = self.noSearchResultsView
                    }
                    Answers.logSearch(withQuery: searchText,customAttributes: nil)
                })
            })
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistInfoCell", for: indexPath)  as! ArtistTableViewCell
        // Configure the cell...
        let artistInfo = artists[(indexPath as NSIndexPath).row]
        cell.configure(artistInfo: artistInfo)
        cell.albumActivityIndicator.startAnimating()
        cell.thumbUrl = artistInfo.thumbUrl // For recycled cells' late image loads.


        if let image = artistInfo.thumbUrl.cachedImage {
            // Cached: set immediately.
            cell.artistArt.image = image
            cell.artistArt.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            cell.artistArt.alpha = 0
            artistInfo.thumbUrl.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell.thumbUrl == artistInfo.thumbUrl {
                    cell.artistArt.image = image
                    UIView.animate(withDuration: 0.3) {
                        cell.artistArt.alpha = 1
                    }
                }
            }
        }


        return cell
    }

    /* override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
     */

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        var artistInfo = artists[indexPath.row]

        let unfollow = UITableViewRowAction(style: .normal, title: "Error") { action, index in
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
                    let success = artistInfo.unfollowArtist()
                    DispatchQueue.main.async(execute: {
                        if success == "1" {
                            artistInfo.followStatus = "0"
                            //self.artists.remove(at: indexPath.row)
                            //tableView.deleteRows(at: [indexPath], with: .automatic)
                            self.artists[(indexPath as NSIndexPath).row].followStatus = "0"
                            Answers.logCustomEvent(withName: "Unfol Swipe", customAttributes: ["Artist ID":artistInfo.artistId])
                        } else if success == "2" {
                            artistInfo.followStatus = "1"
                            self.artists[(indexPath as NSIndexPath).row].followStatus = "1"
                            Answers.logCustomEvent(withName: "Follo Swipe", customAttributes: ["Artist ID":artistInfo.artistId])
                        }
                         tableView.setEditing(false, animated: true)
                    })
                })
            }
        }

        unfollow.backgroundColor = UIColor(red: (48/255), green: (156/255), blue: (172/255), alpha: 1)
        if artistInfo.followStatus == "0" {
            unfollow.title = "Follow"
        } else {
            unfollow.title = "Unfollow"
        }

        return [unfollow]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showArtistReleases",
            let destination = segue.destination as? ArtistReleasesTableViewController,
            let releaseIndex = tableView.indexPathForSelectedRow?.row {
            let artistId = artists[releaseIndex].artistId
            let artistName = artists[releaseIndex].artistName
            self.lastSelectedArtistId = artistId
            self.lastSelectedArtistName = artistName
            destination.artistId = artistId
            destination.artistName = artistName
        } else if segue.identifier == "showArtistReleases",
            let destination = segue.destination as? ArtistReleasesTableViewController {
            destination.artistId = self.lastSelectedArtistId
            destination.artistName = self.lastSelectedArtistName
        }
    }

    func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask(with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                data.map { self.image = UIImage(data: $0) }
            }
        }).resume()
    }
}
