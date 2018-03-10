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

        self.viewControllers![0].title = "All Releases"
        self.viewControllers![0].tabBarItem.image = UIImage(named: "all.png")

        self.viewControllers![1].title = "Your Releases"
        self.viewControllers![1].tabBarItem.image = UIImage(named: "yours.png")

        self.tabBar.tintColor = UIColor(red: 0.24, green: 0.67, blue: 0.73, alpha: 1.0)

        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //print("Should select viewController: \(viewController.title) ?")
        return true
    }

}
