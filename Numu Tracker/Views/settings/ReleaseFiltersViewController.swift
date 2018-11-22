//
//  ReleaseFiltersViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/22/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import Crashlytics

class ReleaseFiltersViewController: UIViewController {

    @IBOutlet weak var albumFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var albumFilterSwitch: UISwitch!
    @IBAction func albumFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "album") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var singlesFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var singlesFilterSwitch: UISwitch!
    @IBAction func singlesFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "single") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var epFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var epFilterSwitch: UISwitch!
    @IBAction func epFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "ep") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var liveFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var liveFilterSwitch: UISwitch!
    @IBAction func liveFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "live") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var compFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var compFilterSwitch: UISwitch!
    @IBAction func compFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "soundtrack") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var remixFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var remixFilterSwitch: UISwitch!
    @IBAction func remixFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "remix") { (result) in
            print(result)
        }
    }
    @IBOutlet weak var otherFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var otherFilterSwitch: UISwitch!
    @IBAction func otherFilterSwitch(_ sender: AnyObject) {
        NumuClient.shared.toggleFilter(filter: "other") { (result) in
            print(result)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Filters")
        loadSettings()
        // Do any additional setup after loading the view.
        Answers.logCustomEvent(withName: "Filters View", customAttributes: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadSettings() {

        if NumuCredential.shared.checkForCredential() {

            self.albumFilterSwitch.isHidden = true
            self.albumFilterSpinner.startAnimating()
            self.singlesFilterSwitch.isHidden = true
            self.singlesFilterSpinner.startAnimating()
            self.epFilterSwitch.isHidden = true
            self.epFilterSpinner.startAnimating()
            self.liveFilterSwitch.isHidden = true
            self.liveFilterSpinner.startAnimating()
            self.compFilterSwitch.isHidden = true
            self.compFilterSpinner.startAnimating()
            self.remixFilterSwitch.isHidden = true
            self.remixFilterSpinner.startAnimating()
            self.otherFilterSwitch.isHidden = true
            self.otherFilterSpinner.startAnimating()

            NumuClient.shared.getFilters {[weak self](json) in
                let user = User(json: json)
                DispatchQueue.main.async(execute: {
                    self?.albumFilterSwitch.isOn = user?.album != "0"
                    self?.albumFilterSwitch.isHidden = false
                    self?.albumFilterSpinner.stopAnimating()

                    self?.singlesFilterSwitch.isOn = user?.single != "0"
                    self?.singlesFilterSwitch.isHidden = false
                    self?.singlesFilterSpinner.stopAnimating()

                    self?.epFilterSwitch.isOn = user?.extendedPlay != "0"
                    self?.epFilterSwitch.isHidden = false
                    self?.epFilterSpinner.stopAnimating()

                    self?.liveFilterSwitch.isOn = user?.live != "0"
                    self?.liveFilterSwitch.isHidden = false
                    self?.liveFilterSpinner.stopAnimating()

                    self?.compFilterSwitch.isOn = user?.soundtrack != "0"
                    self?.compFilterSwitch.isHidden = false
                    self?.compFilterSpinner.stopAnimating()

                    self?.remixFilterSwitch.isOn = user?.remix != "0"
                    self?.remixFilterSwitch.isHidden = false
                    self?.remixFilterSpinner.stopAnimating()

                    self?.otherFilterSwitch.isOn = user?.other != "0"
                    self?.otherFilterSwitch.isHidden = false
                    self?.otherFilterSpinner.stopAnimating()
                })
            }
        } else {
            self.albumFilterSwitch.isEnabled = false
            self.singlesFilterSwitch.isEnabled = false
            self.epFilterSwitch.isEnabled = false
            self.liveFilterSwitch.isEnabled = false
            self.compFilterSwitch.isEnabled = false
            self.remixFilterSwitch.isEnabled = false
            self.otherFilterSwitch.isEnabled = false
        }

    }

}
