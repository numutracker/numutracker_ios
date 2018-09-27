//
//  AboutViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 9/16/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "About View", customAttributes: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
