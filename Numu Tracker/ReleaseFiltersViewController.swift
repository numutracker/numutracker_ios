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
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "album")
        })
    }
    @IBOutlet weak var singlesFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var singlesFilterSwitch: UISwitch!
    @IBAction func singlesFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "single")
        })
    }
    @IBOutlet weak var epFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var epFilterSwitch: UISwitch!
    @IBAction func epFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "ep")
        })
    }
    @IBOutlet weak var liveFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var liveFilterSwitch: UISwitch!
    @IBAction func liveFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "live")
        })
    }
    @IBOutlet weak var compFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var compFilterSwitch: UISwitch!
    @IBAction func compFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "soundtrack")
        })
    }
    @IBOutlet weak var remixFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var remixFilterSwitch: UISwitch!
    @IBAction func remixFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "remix")
        })
    }
    @IBOutlet weak var otherFilterSpinner: UIActivityIndicatorView!
    @IBOutlet weak var otherFilterSwitch: UISwitch!
    @IBAction func otherFilterSwitch(_ sender: AnyObject) {
        DispatchQueue.global(qos: .background).async(execute: {
            let _ = SearchClient.sharedClient.toggleFilter(filter: "other")
        })
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

        if defaults.bool(forKey: "logged") {
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

            DispatchQueue.global(qos: .background).async(execute: {
                let user = User(username: defaults.string(forKey: "username")!)
                DispatchQueue.main.async(execute: {
                    if user?.album == "0" {
                        self.albumFilterSwitch.isOn = false
                    } else {
                        self.albumFilterSwitch.isOn = true
                    }
                    self.albumFilterSwitch.isHidden = false
                    self.albumFilterSpinner.stopAnimating()
                    if user?.single == "0" {
                        self.singlesFilterSwitch.isOn = false
                    } else {
                        self.singlesFilterSwitch.isOn = true
                    }
                    self.singlesFilterSwitch.isHidden = false
                    self.singlesFilterSpinner.stopAnimating()
                    if user?.ep == "0" {
                        self.epFilterSwitch.isOn = false
                    } else {
                        self.epFilterSwitch.isOn = true
                    }
                    self.epFilterSwitch.isHidden = false
                    self.epFilterSpinner.stopAnimating()
                    if user?.live == "0" {
                        self.liveFilterSwitch.isOn = false
                    } else {
                        self.liveFilterSwitch.isOn = true
                    }
                    self.liveFilterSwitch.isHidden = false
                    self.liveFilterSpinner.stopAnimating()
                    if user?.soundtrack == "0" {
                        self.compFilterSwitch.isOn = false
                    } else {
                        self.compFilterSwitch.isOn = true
                    }
                    self.compFilterSwitch.isHidden = false
                    self.compFilterSpinner.stopAnimating()

                    if user?.remix == "0" {
                        self.remixFilterSwitch.isOn = false
                    } else {
                        self.remixFilterSwitch.isOn = true
                    }
                    self.remixFilterSwitch.isHidden = false
                    self.remixFilterSpinner.stopAnimating()

                    if user?.other == "0" {
                        self.otherFilterSwitch.isOn = false
                    } else {
                        self.otherFilterSwitch.isOn = true
                    }
                    self.otherFilterSwitch.isHidden = false
                    self.otherFilterSpinner.stopAnimating()

                })
            })
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
