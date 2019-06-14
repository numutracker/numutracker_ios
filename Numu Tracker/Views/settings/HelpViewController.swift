//
//  HelpViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailDeveloperButton: NumuUIButton!

    @IBOutlet weak var discussOnRedditButtonOutlet: NumuUIButton!

    @IBOutlet weak var joinSlackButton: NumuUIButton!

    @IBAction func discussOnRedditButton(_ sender: NumuUIButton) {
        let url = URL(string: "http://www.reddit.com/r/numutracker")
        UIApplication.shared.open(url!)
    }

    @IBAction func joinSlackButton(_ sender: Any) {
        let appURL = NSURL(string: "twitter://user?screen_name=amiantos")!
        let webURL = NSURL(string: "https://twitter.com/amiantos")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }

    @IBAction func emailDeveloperButtonAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@numutracker.com"])
            mail.setSubject("Numu Tracker Feedback")
            mail.setMessageBody("<p>Numu feedback goes here: </p>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(URL(string: "mailto:info@numutracker.com")!)
        }
    }

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white

        Answers.logCustomEvent(withName: "Help View", customAttributes: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
