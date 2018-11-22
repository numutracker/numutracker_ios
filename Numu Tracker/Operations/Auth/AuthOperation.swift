//
//  LocalAuthOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics

class AuthOperation: AsyncOperation {

    let queue = OperationQueue()

    override func main() {
        print("Running LocalAuthOperation...")
        if NumuCredential.shared.checkForCredential() {
            let authTest = FetchOperation(NumuAPI.shared.getAuth())
            authTest.qualityOfService = .default
            authTest.completionBlock = { [unowned authTest] in
                let json = authTest.json
                if let result = json["result"].string,
                    result == "1" {
                    print("SUCCESS: AuthTest with existing credentials successful!")
                    defaults.logged = true
                    if let username = NumuCredential.shared.getUsername() {
                        Crashlytics.sharedInstance().setUserEmail(username)
                    }
                    self.sendNotifcations()
                    self.state = .isFinished
                } else {
                    print("ERROR: AuthTest with existing credentials unsuccessful!")
                    NumuCredential.shared.removeCredential()
                    self.showLogRegPrompt()
                    self.state = .isFinished
                }
            }
            self.queue.addOperation(authTest)
        } else {
            self.showLogRegPrompt()
        }
    }

    func sendNotifcations() {
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: .LoggedIn, object: self)
            NotificationCenter.default.post(name: .UpdatedArtists, object: self)
        })
    }

    func showLogRegPrompt() {
        if let loginViewController = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "LogRegPrompt") as? UINavigationController {
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate,
                    let appWindow = appDelegate.window!,
                    let rootViewController = appWindow.rootViewController {
                    rootViewController.present(loginViewController, animated: false, completion: nil)
                }
            }
        } else {
            // Display error message?
        }
    }
}
