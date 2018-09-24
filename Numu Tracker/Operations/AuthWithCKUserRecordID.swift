//
//  AuthWithCKUserRecordID.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation

class AuthWithCKUserRecordID: AsyncOperation {
    
    let queue = OperationQueue()
    
    override func main() {
        print("Running AuthWithCKUserRecordID..")
        if let userRecordID = UserDefaults.standard.string(forKey: "userRecordID") {
            // Try to login with CK Record ID
            NumuCredential.shared.storeCredential(username: userRecordID, password: "icloud")
            let authTest = FetchOperation(NumuAPI.shared.getAuth())
            print("Auth Test with Username \(NumuCredential.shared.getUsername())")
            authTest.qualityOfService = .default
            authTest.completionBlock = { [unowned authTest] in
                let json = authTest.json
                if let result = json["result"].string,
                    result == "1" {
                    print("SUCCESS: AuthTest with CK successful!")
                    self.state = .isFinished
                } else {
                    print("ERROR: AuthTest with CK unsuccessful!")
                    NumuCredential.shared.removeCredential()
                    self.state = .isFinished
                }
            }
            self.queue.addOperation(authTest)
        } else {
            print("User record ID does not exist.")
            self.state = .isFinished
        }
    }
}

