//
//  NumuCredential.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuCredential {
    
    static let shared = NumuCredential()
    
    private struct ProtectionSpace {
        static let production = URLProtectionSpace(
            host: "api.numutracker.com",
            port: 443,
            protocol: "https",
            realm: "Authentication Required",
            authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
        static let v2production = URLProtectionSpace(
            host: "www.numutracker.com",
            port: 443,
            protocol: "https",
            realm: "Numu Tracker",
            authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
    }
    
    func storeCredential(username: String?, password: String?) {
        if let username = username,
            let password = password {
            let credential = URLCredential(user: username, password: password, persistence: .synchronizable)
            URLCredentialStorage.shared.setDefaultCredential(credential, for: ProtectionSpace.production)
        }
    }
    
    func removeCredential() {
        if let credential = URLCredentialStorage.shared.defaultCredential(for: ProtectionSpace.production) {
            URLCredentialStorage.shared.remove(
                credential,
                for: ProtectionSpace.production,
                options: ["NSURLCredentialStorageRemoveSynchronizableCredentials": true])
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
    
    func getV2Details() -> (String?, String?) {
        if let credential = URLCredentialStorage.shared.defaultCredential(for: ProtectionSpace.v2production) {
            return (credential.user, credential.password)
        }
        return (nil, nil)
    }
    
}
