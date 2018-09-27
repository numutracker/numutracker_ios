//
//  SettingsTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 1/22/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var createAccountCell: UITableViewCell!
    @IBOutlet weak var createAccountLabel: UILabel!

    @IBOutlet weak var signInToAccountCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!

    @IBOutlet weak var releaseFiltersCell: UITableViewCell!
    @IBOutlet weak var notificationsCell: UITableViewCell!

    @IBOutlet weak var appleMusicCell: UITableViewCell!
    @IBOutlet weak var spotifyCell: UITableViewCell!
    @IBOutlet weak var lastFmCell: UITableViewCell!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAt: indexPath)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountButtonSegue" {
            //print("Trying to segue...")
        }
    }
}
