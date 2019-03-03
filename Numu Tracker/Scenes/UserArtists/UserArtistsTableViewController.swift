//
//  UserArtistsTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class UserArtistsTableViewController: UITableViewController {

    var artistEngine: APIArtists = APIArtists()

    @IBAction func refresh(_ sender: UIRefreshControl) {
        print("Refreshed")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "artistCell")

        self.artistEngine.get {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistEngine.artists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let artistCell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }

        artistCell.artist = self.artistEngine.artists[indexPath.row]

        return artistCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let artistCell = self.tableView.cellForRow(at: indexPath) as? ArtistTableViewCell else { return nil }
        return artistCell.getEditActions()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = self.artistEngine.artists[indexPath.row]

        guard let artistReleasesView = self.storyboard?.instantiateViewController(withIdentifier: "artistReleasesTableViewControler") as? ArtistReleasesTableViewController else { return }

        artistReleasesView.artist = artist

        self.navigationController?.pushViewController(artistReleasesView, animated: true)






    }

}
