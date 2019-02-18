//
//  NumuTabBarController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/14/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class NumuTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 0.24, green: 0.67, blue: 0.73, alpha: 1.0)
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
