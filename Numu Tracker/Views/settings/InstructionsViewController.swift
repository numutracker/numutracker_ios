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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
