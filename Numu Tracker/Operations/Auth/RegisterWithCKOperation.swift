//
//  RegisterWithCKUserRecordID.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation

class RegisterWithCKOperation: AsyncOperation {

    override func main() {
        print("Running RegisterWithCKUserRecordID Operation...")
        // Is user already logged into an account that is not tied to a CloudID?
        if let loggedUserName = NumuCredential.shared.getUsername(),
            let userRecordID = UserDefaults.standard.string(forKey: "userRecordID"),
            loggedUserName != userRecordID {
            NumuClient.shared.addCKIDtoAccount(iCloudID: userRecordID) { (result) in
                DispatchQueue.main.async(execute: {
                    if result == "1" {
                        print("Success adding iCloud ID to existing account")
                        NumuCredential.shared.storeCredential(username: userRecordID, password: "icloud")
                        self.state = .isFinished
                    }
                })
            }
        } else if let userRecordID = UserDefaults.standard.string(forKey: "userRecordID"),
            !defaults.logged {
            NumuClient.shared.authorizeRegisterWithCK(iCloudID: userRecordID) { (result) in
                DispatchQueue.main.async(execute: {
                    if result == "1" {
                        print("Success registering with iCloud ID")
                        NumuCredential.shared.storeCredential(username: userRecordID, password: "icloud")
                        self.state = .isFinished
                    }
                })
            }
        } else {
            self.state = .isFinished
        }
    }
}
