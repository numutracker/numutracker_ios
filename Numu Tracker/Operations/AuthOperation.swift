//
//  AuthOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

final class AuthOperation: AsyncOperation {
    
    /*
    let queue = OperationQueue()
    */
    /*
    
    func loginOrRegisterWithCloudKit(userRecordID: String) {
        if let currentUsername = NumuCredential.shared.getUsername(),
            currentUsername != userRecordID {
            // User has existing login info that isn't their userRecordID
            // We should add their userRecordID to their numu account info
            NumuClient.shared.addCKIDtoAccount(icloud_id: userRecordID) { (result) in
                DispatchQueue.main.async(execute: {
                    if result == "1" {
                        print("Success adding iCloud ID to existing account")
                        NumuCredential.shared.storeCredential(username: userRecordID, password: "icloud")
                    }
                })
            }
        } else if !NumuCredential.shared.checkForCredential() {
            NumuCredential.shared.storeCredential(username: userRecordID, password: "icloud")
            let authTest = FetchOperation(NumuAPI.shared.getAuth())
            print("Auth Test with Username \(NumuCredential.shared.getUsername())")
            authTest.qualityOfService = .default
            authTest.completionBlock = { [unowned authTest] in
                let json = authTest.json
                if let result = json["result"].string,
                    result == "1" {
                    print("SUCCESS: AuthTest successful!")
                } else {
                    print("ERROR: AuthTest unsuccessful!")
                    NumuCredential.shared.removeCredential()
                    // Register with CK ID here
                }
            }
            queue.addOperation(authTest)
        }
    }
     */
    
    override func main() {
        
        print("Running AuthOperation...")
        
        let userRecordID = UserDefaults.standard.string(forKey: "userRecordID")
        
        print("UserRecordID: \(userRecordID)")

        /*
        // Fetch and save users iCloud userRecordID
        if self.userRecordID == nil {
            iCloudUserIDAsync() {
                recordID, error in
                if let userID = recordID?.recordName {
                    print("received iCloudID \(userID)")
                    self.loginOrRegisterWithCloudKit(userRecordID: userID)
                } else {
                    print("Fetched iCloudID was nil")
                    // Display registration form
                }
            }
        }
 
        //self.userRecordID = nil
        //NumuCredential.shared.removeCredential()
        //NumuCredential.shared.removeCredential()
        
        if NumuCredential.shared.checkForCredential() {
            // Users have credentials stored already, test them...
            let authTest = FetchOperation(NumuAPI.shared.getAuth())
            print("Auth Test with Username \(NumuCredential.shared.getUsername())")
            authTest.qualityOfService = .default
            authTest.completionBlock = { [unowned authTest] in
                let json = authTest.json
                if let result = json["result"].string,
                    result == "1" {
                    print("SUCCESS: AuthTest successful!")
                } else {
                    print("ERROR: AuthTest unsuccessful!")
                    NumuCredential.shared.removeCredential()
                    self.queue.addOperation(self)
                }
            }
            queue.addOperation(authTest)
        }
        
        // Check if user is already logged into an account...
        if NumuCredential.shared.checkForCredential() && self.userRecordID != nil {
            if let recordID = self.userRecordID,
                NumuCredential.shared.getUsername() != recordID {
                // They're logged in with a non-iCloud ID already, so send the CKID...
                NumuClient.shared.addCKIDtoAccount(icloud_id: recordID) { (result) in
                    DispatchQueue.main.async(execute: {
                        if result == "1" {
                            print("Success adding iCloud ID to existing account")
                            NumuCredential.shared.storeCredential(username: recordID, password: "icloud")
                        }
                    })
                }
            }
        }
        
        
        if self.userRecordID != nil && !NumuCredential.shared.checkForCredential() {
            // They are not logged in already, we need to create an account with their CKID.
            if let userRecord = self.userRecordID {
                NumuClient.shared.authorizeRegisterWithCK(icloud_id: userRecord) { (result) in
                    DispatchQueue.main.async(execute: {
                        if result == "1" {
                            print("Success registering with iCloud ID")
                        }
                    })
                }
            }
        }
        
        if self.userRecordID == nil && !NumuCredential.shared.checkForCredential() {
            // We need to display the registration prompt
            let controller = UIDevice().screenType == .iPhone4 ? "LogRegPromptSmall" : "LogRegPrompt"
            let loginViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: controller) as! UINavigationController
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate,
                    let appWindow = appDelegate.window!,
                    let rootViewController = appWindow.rootViewController {
                    rootViewController.present(loginViewController, animated: true, completion: nil)
                }
            }
        }
        
        */
        
    }
    

}
