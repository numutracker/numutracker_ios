//
//  TestingViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/13/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let storageController = StorageController()
        //storageController.populateArtists()

        storageController.populateReleases()

        storageController.populateArtists()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
