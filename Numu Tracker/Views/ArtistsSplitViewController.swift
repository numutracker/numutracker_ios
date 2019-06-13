//
//  ArtistsSplitViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 6/13/19.
//  Copyright © 2019 Numu Tracker. All rights reserved.
//

import UIKit

class ArtistsSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
        self.delegate = self
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}
