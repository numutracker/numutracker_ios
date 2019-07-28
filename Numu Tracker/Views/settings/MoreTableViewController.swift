//
//  MoreTableViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 6/14/19.
//  Copyright © 2019 Numu Tracker. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    @IBAction func patronButton(_ sender: NumuUIButton) {
        UIApplication.shared.open(
            URL(
                string: "https://www.patreon.com/amiantos?utm_source=numu_ios&utm_medium=button&utm_campaign=more_screen"
            )!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func visitBlogButton(_ sender: NumuUIButton) {
        UIApplication.shared.open(
            URL(string: "https://amiantos.net/?utm_source=numu_ios&utm_medium=button&utm_campaign=more_screen")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func learnMoreButton(_ sender: NumuUIButton) {
        UIApplication.shared.open(
            URL(string: "https://www.github.com/numutracker/numutracker_ios")!,
            options: [:],
            completionHandler: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
