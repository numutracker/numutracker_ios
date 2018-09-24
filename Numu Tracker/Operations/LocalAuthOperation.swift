//
//  LocalAuthOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import UIKit

class LocalAuthOperation: AsyncOperation {
    
    let queue = OperationQueue()
    
    // Fall back if unable to auth with CloudKit
    
    override func main() {
        print("Running LocalAuthOperation...")
        if !defaults.logged {
            if NumuCredential.shared.checkForCredential() {
                let authTest = FetchOperation(NumuAPI.shared.getAuth())
                print("Auth Test with Username \(NumuCredential.shared.getUsername())")
                authTest.qualityOfService = .default
                authTest.completionBlock = { [unowned authTest] in
                    let json = authTest.json
                    if let result = json["result"].string,
                        result == "1" {
                        print("SUCCESS: AuthTest with existing credentials successful!")
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
        } else {
            print("Already logged in some other way.")
            self.state = .isFinished
        }
    }
    
    func showLogRegPrompt() {
        let controller = UIDevice().screenType == .iPhone4 ? "LogRegPromptSmall" : "LogRegPrompt"
        let loginViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: controller) as! UINavigationController
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(loginViewController, animated: false, completion: nil)
            }
        }
    }
    
}
