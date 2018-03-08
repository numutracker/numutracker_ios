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

class HelpViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var emailDeveloperButton: NumuUIButton!

    @IBOutlet weak var discussOnRedditButtonOutlet: NumuUIButton!

    @IBAction func discussOnRedditButton(_ sender: NumuUIButton) {
        let url = URL(string: "http://www.reddit.com/r/numutracker")
        UIApplication.shared.open(url!)
    }

    @IBAction func emailDeveloperButtonAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["bradroot@me.com"])
            mail.setSubject("Numu Tracker Feedback")
            mail.setMessageBody("<p>Numu feedback goes here: </p>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationController?.navigationBar.tintColor = .white

        emailDeveloperButton.backgroundColor = .clear
        emailDeveloperButton.layer.cornerRadius = 5
        emailDeveloperButton.layer.borderWidth = 1
        emailDeveloperButton.layer.borderColor = UIColor.gray.cgColor

        discussOnRedditButtonOutlet.backgroundColor = .clear
        discussOnRedditButtonOutlet.layer.cornerRadius = 5
        discussOnRedditButtonOutlet.layer.borderWidth = 1
        discussOnRedditButtonOutlet.layer.borderColor = UIColor.gray.cgColor

        Answers.logCustomEvent(withName: "Help View", customAttributes: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
