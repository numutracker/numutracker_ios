//
//  ArtistsTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/15/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics
import Kingfisher

class ArtistsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var importAppleMusicActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var importAppleMusicButton: UIButton!
    @IBAction func importAppleMusicButton(_ sender: Any) {
        importAppleMusicActivityIndicator.startAnimating()
        let importAMOperation = ImportAppleMusicOperation()
        let queue = OperationQueue()
        importAMOperation.qualityOfService = .userInteractive
        importAMOperation.completionBlock = {
            DispatchQueue.main.async {
                self.importAppleMusicActivityIndicator.stopAnimating()
            }
        }
        queue.addOperation(importAMOperation)
    }

    @IBOutlet weak var importSpotifyActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var importSpotifyButton: NumuUIButton!
    @IBAction func importSpotifyButton(_ sender: NumuUIButton) {
        importSpotifyActivityIndicator.startAnimating()
        let importSpotifyOperation = ImportSpotifyOperation()
        let queue = OperationQueue()
        importSpotifyOperation.qualityOfService = .userInteractive
        importSpotifyOperation.completionBlock = {
            DispatchQueue.main.async {
                self.importSpotifyActivityIndicator.stopAnimating()
            }
        }
        queue.addOperation(importSpotifyOperation)
    }

    var artists: [ArtistItem] = [] {
        didSet {
            if viewState == .user {
                artistsDictionary = [:]
                artistsSectionTitles = []
                for artist in artists {
                    var artistKey = String(artist.artistName.prefix(1).uppercased())
                    switch sortMethod {
                    case "name_first":
                        artistKey = String(artist.artistName.prefix(1).uppercased())
                        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: artistKey)) || !CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: artistKey)) {
                            artistKey = "#"
                        }
                    case "name":
                        artistKey = String(artist.sortName.prefix(1).uppercased())
                        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: artistKey)) || !CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: artistKey)) {
                            artistKey = "#"
                        }
                    default:
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM d, yyyy" //Your date format
                        guard let date = dateFormatter.date(from: artist.recentRelease) else {
                            fatalError()
                        }
                        dateFormatter.dateFormat = "yyyy"
                        if artist.recentRelease == "December 31, 1969" {
                            artistKey = "None"
                        } else {
                            artistKey = String(dateFormatter.string(from: date).prefix(4))
                        }
                    }
                    if var artistValues = artistsDictionary[artistKey] {
                        artistValues.append(artist)
                        artistsDictionary[artistKey] = artistValues
                    } else {
                        artistsDictionary[artistKey] = [artist]
                    }
                }
                artistsSectionTitles = [String](artistsDictionary.keys)
                switch sortMethod {
                case "name_first":
                    artistsSectionTitles = artistsSectionTitles.sorted(by: { $0 < $1 })
                    if !artistsSectionTitles.isEmpty {
                        if artistsSectionTitles[0] == "#" {
                            artistsSectionTitles.remove(at: 0)
                            artistsSectionTitles.append("#")
                        }
                    }
                case "name":
                    artistsSectionTitles = artistsSectionTitles.sorted(by: { $0 < $1 })
                    if !artistsSectionTitles.isEmpty {
                        if artistsSectionTitles[0] == "#" {
                            artistsSectionTitles.remove(at: 0)
                            artistsSectionTitles.append("#")
                        }
                    }
                default:
                    artistsSectionTitles = artistsSectionTitles.sorted(by: { $0 > $1 })
                    if !artistsSectionTitles.isEmpty {
                        if artistsSectionTitles[0] == "None" {
                            artistsSectionTitles.remove(at: 0)
                            artistsSectionTitles.append("None")
                        }
                    }
                }
            }
        }
    }
    var artistsDictionary: [String: [ArtistItem]] = [:]
    var artistsSectionTitles: [String] = []

    var sortMethod: String = UserDefaults.standard.string(forKey: "sortArtists") ?? "name" {
        didSet {
            UserDefaults.standard.set(self.sortMethod, forKey: "sortArtists")
            loadArtists()
        }
    }

    var lastSelectedArtistId: String = ""
    var lastSelectedArtistName: String = ""

    var searchTerms: String?

    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBAction func sortButtonAction(_ sender: Any) {
        let sortView = NumuSortView()
        sortView.providesPresentationContextTransitionStyle = true
        sortView.definesPresentationContext = true
        sortView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        sortView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        sortView.modalPresentationCapturesStatusBarAppearance = true
        sortView.sortDelegate = self
        if let appDelegate = UIApplication.shared.delegate,
            let appWindow = appDelegate.window!,
            let rootViewController = appWindow.rootViewController {
            rootViewController.present(sortView, animated: true, completion: nil)
        }
    }

    enum States {
        case user, search
    }

    var viewState = States.user {
        didSet {
            if viewState == .user {
                self.navigationItem.title = "Your Artists"
                self.sortButton.isEnabled = true
            } else {
                self.navigationItem.title = "Search Artists"
                self.sortButton.isEnabled = false
            }
        }
    }

    @IBOutlet var noResultsView: UIView!
    @IBOutlet var noSearchResultsView: UIView!

    var artist: ArtistItem?

    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet var footerView: UIView!

    fileprivate func loadArtists() {
        // Get list of artists...

        NumuClient.shared.getArtists(sortBy: self.sortMethod) {[weak self](artists) in
            self?.artists = artists
            DispatchQueue.main.async(execute: {
                self?.loadTable()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        tableView.backgroundView = UIView()
        tableView.keyboardDismissMode = .onDrag
        searchController.searchBar.placeholder = "Search all artists"
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.keyboardType = .alphabet
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.backgroundColor = .black
        searchController.searchBar.tintColor = .white
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        sortButton.tintColor = UIColor.white

        self.view?.snapshotView(afterScreenUpdates: true)

        importAppleMusicButton.backgroundColor = .clear
        importAppleMusicButton.layer.cornerRadius = 5
        importAppleMusicButton.layer.borderWidth = 1
        importAppleMusicButton.layer.borderColor = UIColor.gray.cgColor

        importSpotifyButton.backgroundColor = .clear
        importSpotifyButton.layer.cornerRadius = 5
        importSpotifyButton.layer.borderWidth = 1
        importSpotifyButton.layer.borderColor = UIColor.gray.cgColor

        var newFrame = noResultsView.frame
        var height: CGFloat = self.tableView.bounds.height
        height -= UIApplication.shared.statusBarFrame.size.height
        height -= (self.navigationController?.navigationBar.frame.size.height)!
        height -= (self.tabBarController?.tabBar.frame.size.height)!
        newFrame.size.height = height
        noResultsView.frame = newFrame

        loadArtists()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actOnImportNotification),
                                               name: .UpdatedArtists,
                                               object: nil)

        self.tableView.addSubview(self.artistRefreshControl)

        Answers.logCustomEvent(withName: "Your Artists View", customAttributes: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }

    @objc func actOnImportNotification() {
        loadArtists()
    }

    lazy var artistRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.artists.removeAll()
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        self.viewState = .user
        self.searchController.isActive = false
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.isHidden = true
        self.actOnImportNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if viewState == .user {
            return artistsSectionTitles.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewState == .user {
            let artistKey = artistsSectionTitles[section]
            if let artistValues = artistsDictionary[artistKey] {
                return artistValues.count
            }
        }
        return artists.count

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewState = .search
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.viewState = .user
        self.artists.removeAll()
        self.tableView.reloadData()
        self.searchController.searchBar.showsCancelButton = false
        self.tableView.tableFooterView = footerView
        self.actOnImportNotification()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }

    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 1)
    }

    @objc func reload() {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, searchText.count > 2 {
            self.viewState = .search
            self.artists.removeAll()
            self.tableView.reloadData()
            self.tableView.tableFooterView = footerView
            NumuClient.shared.getArtistSearch(search: searchText) {[weak self](artists) in
                self?.artists = artists
                DispatchQueue.main.async(execute: {
                    self?.loadTable()
                    Answers.logSearch(withQuery: searchText, customAttributes: nil)
                })
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.isActive = false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "artistInfoCell", for: indexPath) as? ArtistTableViewCell else {
                return UITableViewCell()
        }
        // Configure the cell...

        if viewState == .user {
            let artistKey = artistsSectionTitles[indexPath.section]
            if let artistValues = artistsDictionary[artistKey] {
                let artistInfo = artistValues[indexPath.row]
                cell.configure(artistInfo: artistInfo)
                cell.albumActivityIndicator.startAnimating()
                cell.thumbUrl = artistInfo.thumbUrl // For recycled cells' late image loads.

                cell.artistArt.kf.setImage(
                    with: cell.thumbUrl,
                    options: [.transition(.fade(0.2))])

                return cell
            }
        }

        let artistInfo = artists[indexPath.row]
        cell.configure(artistInfo: artistInfo)
        cell.albumActivityIndicator.startAnimating()
        cell.thumbUrl = artistInfo.thumbUrl // For recycled cells' late image loads.

        cell.artistArt.kf.setImage(
            with: cell.thumbUrl,
            options: [.transition(.fade(0.2))])

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewState == .user {
            return "  " + artistsSectionTitles[section]
        }
        return nil
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if viewState == .user {
            if sortMethod == "date" {
                var result: [String] = []
                for year in artistsSectionTitles {
                    if year != "None" {
                        result.append("’" + String(year.suffix(2)))
                    }
                }
                return result
            }
            return artistsSectionTitles
        }
        return nil
    }

    override func tableView(
        _ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        var artistInfo = artists[indexPath.row]

        let unfollow = UITableViewRowAction(style: .normal, title: "Error") { _, index in
            if !defaults.logged {
                if let loginViewController = self.storyboard?.instantiateViewController(
                        withIdentifier: "LogRegPrompt") as? UINavigationController {
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                }
            } else {
                artistInfo.unfollowArtist { (success) in
                    DispatchQueue.main.async(execute: {
                        if success == "1" {
                            artistInfo.followStatus = "0"
                            self.artists[index.row].followStatus = "0"
                            Answers.logCustomEvent(
                                withName: "Unfol Swipe", customAttributes: ["Artist ID": artistInfo.artistId])
                        } else if success == "2" {
                            artistInfo.followStatus = "1"
                            self.artists[index.row].followStatus = "1"
                            Answers.logCustomEvent(
                                withName: "Follo Swipe", customAttributes: ["Artist ID": artistInfo.artistId])
                        }
                        tableView.setEditing(false, animated: true)
                    })
                }
            }
        }

        unfollow.backgroundColor = .background
        unfollow.title = artistInfo.followStatus == "0" ? "Follow" : "Unfollow"

        return [unfollow]
    }

    func loadTable() {
        self.tableView.reloadData()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.tableFooterView = UIView()
        self.artistRefreshControl.endRefreshing()
        self.searchController.searchBar.isHidden = false
        if self.artists.isEmpty,
            self.viewState == .search {
            self.tableView.tableFooterView = self.noSearchResultsView
        }
        if self.artists.isEmpty,
            self.viewState == .user {
            self.tableView.tableFooterView = self.noResultsView
        }

        if self.viewState == .user {
            self.searchController.searchBar.text = ""
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.lightText
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArtistReleases",
            let destination = segue.destination as? ArtistReleasesTableViewController,
            let releaseIndex = tableView.indexPathForSelectedRow?.row,
            let sectionIndex = tableView.indexPathForSelectedRow?.section {
            self.searchTerms = searchController.searchBar.text

            var artistId = artists[releaseIndex].artistId
            var artistName = artists[releaseIndex].artistName
            if viewState == .user {
                let section = artistsSectionTitles[sectionIndex]
                let dict = artistsDictionary[section]
                let artist = dict![releaseIndex]
                artistId = artist.artistId
                artistName = artist.artistName
            }

            self.lastSelectedArtistId = artistId
            self.lastSelectedArtistName = artistName
            destination.artistId = artistId
            destination.artistName = artistName
        }
    }
}

extension ArtistsTableViewController: SortViewDelegate {
    func sortOptionTapped(name: String) {
        self.sortMethod = name
    }
}

extension UISearchController {
    override open func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
        super.viewDidDisappear(animated)
    }
}
