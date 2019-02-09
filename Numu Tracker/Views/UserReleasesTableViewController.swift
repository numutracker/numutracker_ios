//
//  UserReleasesTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class UserReleasesTableViewController: UITableViewController {
    
    var releases: [Release] = []
    var releaseEngine: NumuAPIReleases = NumuAPIReleases(releaseType: .unlistened)
    
    @IBAction func releaseTypeChanged(_ sender: UISegmentedControl) {
        self.changeDataSource(segmentIndex: sender.selectedSegmentIndex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ReleaseTableViewCell", bundle: nil), forCellReuseIdentifier: "releaseCell")

        self.releaseEngine.get {
            self.releases = self.releaseEngine.releases
            self.tableView.reloadData()
        }
    }

    func changeDataSource(segmentIndex: Int) {
        self.releases.removeAll()
        self.tableView.reloadData()
        switch segmentIndex {
        case 1:
            self.releaseEngine = NumuAPIReleases(releaseType: .released)
        case 2:
            self.releaseEngine = NumuAPIReleases(releaseType: .upcoming)
        case 3:
            self.releaseEngine = NumuAPIReleases(releaseType: .newAdditions)
        default:
            self.releaseEngine = NumuAPIReleases(releaseType: .unlistened)
        }
        self.releaseEngine.get {
            self.releases = self.releaseEngine.releases
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.releases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let releaseCell = tableView.dequeueReusableCell(
            withIdentifier: "releaseCell", for: indexPath
        ) as? ReleaseTableViewCell else { return UITableViewCell() }

        releaseCell.release = self.releases[indexPath.row]

        return releaseCell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = self.tableView.cellForRow(at: indexPath) as! ReleaseTableViewCell
        return cell.getEditActions()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
