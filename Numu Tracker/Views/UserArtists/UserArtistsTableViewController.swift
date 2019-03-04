//
//  UserArtistsTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class UserArtistsTableViewController: UITableViewController {

    var lastResult: StorageResult?
    var viewModel: UserArtistsViewModel?
    var artistsSectionTitles: [String] = []
    var artistsSectionDictionaries: [String: [Artist]] = [:]

    @IBOutlet weak var artistRefreshControl: UIRefreshControl!
    @IBAction func refresh(_ sender: UIRefreshControl) {
        print("Refreshed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = UserArtistsViewModel(delegate: self)

        self.tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "artistCell")

        // Hacky workaround to get refresh control to be white
        artistRefreshControl.tintColor = .white
        self.tableView.contentOffset = CGPoint(x: 0, y: -artistRefreshControl.frame.size.height)
        self.refreshControl?.beginRefreshing()

        self.viewModel?.loadArtists()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.artistsSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let artistKey = artistsSectionTitles[section]
        if let artists = artistsSectionDictionaries[artistKey] {
            return artists.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let artistCell = tableView.dequeueReusableCell(
            withIdentifier: "artistCell", for: indexPath
        ) as? ArtistTableViewCell else { return UITableViewCell() }

        let artistKey = artistsSectionTitles[indexPath.section]
        if let artistValues = artistsSectionDictionaries[artistKey] {
            artistCell.artist = artistValues[indexPath.row]
        }

        return artistCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let artistCell = self.tableView.cellForRow(at: indexPath) as? ArtistTableViewCell else { return nil }
        return artistCell.getEditActions()
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return artistsSectionTitles
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  " + artistsSectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor.lightText
        }
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let artist = self.artists[indexPath.row]
//
//        guard let artistReleasesView = self.storyboard?.instantiateViewController(withIdentifier: "artistReleasesTableViewControler") as? ArtistReleasesTableViewController else { return }
//
//        artistReleasesView.artist = artist
//
//        self.navigationController?.pushViewController(artistReleasesView, animated: true)
//
//    }

}

extension UserArtistsTableViewController: UserArtistsViewModelDelegate {
    func refreshData() {
        if let artists = self.viewModel?.artists, let sections = self.viewModel?.artistsSectionTitles, let sectionDictionaries = self.viewModel?.artistsSectionDictionaries {
            self.artistsSectionTitles = sections
            self.artistsSectionDictionaries = sectionDictionaries
            artistRefreshControl.endRefreshing()
            self.tableView.reloadData()
        }

    }
}
