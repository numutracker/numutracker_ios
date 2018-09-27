//
//  NotificationsViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/24/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import UserNotifications
import Crashlytics

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificationStatusLabel: UILabel!
    @IBOutlet weak var thirtyDaysButtonView: UIView!
    @IBOutlet weak var oneYearButtonView: UIView!
    @IBOutlet weak var thirtyDaysTitleLabel: UILabel!
    @IBOutlet weak var oneYearTitleLabel: UILabel!
    @IBOutlet weak var thirtyDaysCostLabel: UILabel!
    @IBOutlet weak var oneYearCostLabel: UILabel!
    @IBOutlet weak var thirtyDaysLineView: UIView!
    @IBOutlet weak var oneYearLineView: UIView!

    @IBAction func newReleased(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "newReleased")
    }
    @IBOutlet weak var newReleased: UISwitch!

    @IBAction func newAnnouncements(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "newAnnouncements")
    }
    @IBOutlet weak var newAnnouncements: UISwitch!

    @IBAction func moreReleases(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "moreReleases")
    }
    @IBOutlet weak var moreReleases: UISwitch!

    func notificationsSwitch(state: Bool, type: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, _) in
            // actions based on whether notifications were authorized or not
            guard granted else { return }
            defaults.set(state, forKey: type)

            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

         if defaults.logged {
            if defaults.newReleased {
                self.newReleased.isOn = true
                self.notificationsSwitch(state: true, type: "newReleased")
            }
            if defaults.newAnnouncements {
                self.newAnnouncements.isOn = true
                self.notificationsSwitch(state: true, type: "newAnnouncements")
            }
            if defaults.moreReleases {
                self.moreReleases.isOn = true
                self.notificationsSwitch(state: true, type: "moreReleases")
            }
        } else {
            self.newReleased.isEnabled = false
            self.newAnnouncements.isEnabled = false
            self.moreReleases.isEnabled = false
        }

        Answers.logCustomEvent(withName: "Notification Screen", customAttributes: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
