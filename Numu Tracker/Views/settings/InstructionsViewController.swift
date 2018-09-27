//
//  InstructionsViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 9/16/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Answers.logCustomEvent(withName: "Instructions View", customAttributes: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
