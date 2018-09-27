//
//  NumuCredential.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/10/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation

class NumuCredential {
    
    static let shared = NumuCredential()
    
    private struct ProtectionSpace {
        static let production = URLProtectionSpace(host: "www.numutracker.com", port: 443, protocol: "https", realm: "Numu Tracker", authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
    }
    
    func storeCredential(username: String?, password: String?) {
        if let username = username,
            let password = password {
            self.removeCredential() // Remove current default credential
            let credential = URLCredential(user: username, password: password, persistence: .synchronizable)
            URLCredentialStorage.shared.setDefaultCredential(credential, for: ProtectionSpace.production)
            defaults.logged = true
        }
    }
    
    func removeCredential() {
        if let credential = URLCredentialStorage.shared.defaultCredential(for: ProtectionSpace.production) {
            URLCredentialStorage.shared.remove(credential, for: ProtectionSpace.production, options: ["NSURLCredentialStorageRemoveSynchronizableCredentials": true])
            defaults.logged = false
        }
    }
    
    func checkForCredential() -> Bool {
        if URLCredentialStorage.shared.defaultCredential(for: ProtectionSpace.production) != nil {
            return true
        } else {
            return false
        }
    }
    
    func getUsername() -> String? {
        if let credential = URLCredentialStorage.shared.defaultCredential(for: ProtectionSpace.production) {
            return credential.user
        }
        return nil
    }
    
}
