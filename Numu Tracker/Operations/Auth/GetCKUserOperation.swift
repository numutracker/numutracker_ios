//
//  CKUserRecordIDOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/23/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import CloudKit

class GetCKUserOperation: AsyncOperation {
    
    override func main() {
        print("Running CKUserRecordIDOperation..")
        if UserDefaults.standard.string(forKey: "userRecordID") == nil {
            CKContainer.default().fetchUserRecordID { recordID, error in
                guard let recordName = recordID?.recordName, error == nil else {
                    print(error!.localizedDescription)
                    self.state = .isFinished
                    return
                }
                UserDefaults.standard.set(recordName, forKey: "userRecordID")
                print("Got user record ID \(recordName))")
                self.state = .isFinished
            }
        } else {
            self.state = .isFinished
        }
    }
    
}
