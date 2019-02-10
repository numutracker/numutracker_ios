//
//  UserReleasesTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class UserReleasesTableViewController: UITableViewController {

    var releaseEngine: NumuAPIReleases = NumuAPIReleases(releaseType: .unlistened)

    @IBAction func releaseTypeChanged(_ sender: UISegmentedControl) {
        self.changeDataSource(segmentIndex: sender.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ReleaseTableViewCell", bundle: nil), forCellReuseIdentifier: "releaseCell")

        self.releaseEngine.get {
            self.tableView.reloadData()
        }
    }

    func changeDataSource(segmentIndex: Int) {
        self.releaseEngine.reset()
        self.tableView.reloadData()

        switch segmentIndex {
        case 1:
            self.releaseEngine.releaseType = .released
        case 2:
            self.releaseEngine.releaseType = .upcoming
        case 3:
            self.releaseEngine.releaseType = .newAdditions
        default:
            self.releaseEngine.releaseType = .unlistened
        }

        self.releaseEngine.get {
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.releaseEngine.releases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let releaseCell = tableView.dequeueReusableCell(
            withIdentifier: "releaseCell", for: indexPath
        ) as? ReleaseTableViewCell else { return UITableViewCell() }

        releaseCell.release = self.releaseEngine.releases[indexPath.row]

        return releaseCell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let releaseCell = self.tableView.cellForRow(at: indexPath) as? ReleaseTableViewCell else { return nil }
        return releaseCell.getEditActions()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
