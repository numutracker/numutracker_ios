//
//  AppDelegate.swift
//  Numu Tracker
//
//  Created by Bradley Root on 9/11/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import PusherSwift
import UserNotifications
import SwiftyJSON
import Fabric
import Crashlytics
import CloudKit
import SpotifyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Production
    let pusher = Pusher(key: "")

    // Development
    //let pusher = Pusher(key: "")
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        
        NumuReviewHelper.incrementActivityCount()
        
        let redirectURL: URL = URL(string: "numu://")!
        SpotifyLogin.shared.configure(clientID: "SPOTIFY_CLIENT_ID", clientSecret: "SPOTIFY_CLIENT_SECRET", redirectURL: redirectURL)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.runLogInOperations), name: .LoggedOut, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.ckDataChange), name: Notification.Name.CKAccountChanged, object: nil)
        
        runLogInOperations()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { (error) in }
        return handled
    }
    
    @objc func ckDataChange() {
        // Need to re-run authorization procedure here.
        runLogInOperations()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pusher.nativePusher.register(deviceToken: deviceToken)
        if let username = NumuCredential.shared.getUsername() {
            if defaults.newReleased {
                pusher.nativePusher.subscribe(interestName: "newReleased_" + username)
                print("Turned on new notifications")
            } else {
                pusher.nativePusher.unsubscribe(interestName: "newReleased_" + username)
                print("Turned off new notifications")
            }

            if defaults.newAnnouncements {
                pusher.nativePusher.subscribe(interestName: "newAnnouncements_" + username)
                print("Turned on new music friday notifications")
            } else {
                pusher.nativePusher.unsubscribe(interestName: "newAnnouncements_" + username)
                print("Turned off new music friday notifications")
            }

            if defaults.moreReleases {
                pusher.nativePusher.subscribe(interestName: "moreReleases_" + username)
                print("Turned on more releases notifications")
            } else {
                pusher.nativePusher.unsubscribe(interestName: "moreReleases_" + username)
                print("Turned off more releases notifications")
            }
        }
    }

    @objc fileprivate func runLogInOperations() {
        let queue = OperationQueue()
        
        // Get and store CK record ID if available
        let getCKUserOperation = GetCKUserOperation()
        // If user account exists already, link it to CK or create new account
        let registerWithCKOperation = RegisterWithCKOperation()
        // Try to auth with any credentials
        let authOperation = AuthOperation()
        
        registerWithCKOperation.addDependency(getCKUserOperation)
        authOperation.addDependency(registerWithCKOperation)
        authOperation.completionBlock = {
            print("Finished Auth Process!!!")
            DispatchQueue.main.async(execute: {
                if defaults.logged {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
        queue.addOperations([getCKUserOperation, registerWithCKOperation, authOperation], waitUntilFinished: false)
    }

}
