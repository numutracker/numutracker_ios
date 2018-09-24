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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Production
    let pusher = Pusher(key: "")

    // Development
    //let pusher = Pusher(key: "")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        
        NumuReviewHelper.incrementActivityCount()
        
        if NumuCredential.shared.checkForCredential() && defaults.logged == false {
            // If iCloud-synced credentials exist mark user as logged in.
            defaults.logged = true
        }
        
        if defaults.logged {

            if let username = NumuCredential.shared.getUsername() {
                Crashlytics.sharedInstance().setUserEmail(username)
            }

            UIApplication.shared.registerForRemoteNotifications()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnClosedPrompt), name: .ClosedLogRegPrompt, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ckDataChange), name: Notification.Name.CKAccountChanged, object: nil)
        
        let queue = OperationQueue()
        let ckOperation = CKUserRecordIDOperation()
        let ckAuthOperation = AuthWithCKUserRecordID()
        let ckRegisterOperation = RegisterWithCKUserRecordID()
        let localAuthOperation = LocalAuthOperation()
        ckAuthOperation.addDependency(ckOperation)
        ckRegisterOperation.addDependency(ckAuthOperation)
        localAuthOperation.addDependency(ckRegisterOperation)
        localAuthOperation.completionBlock = {
            print("Finished Auth Process!!!")
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: .LoggedIn, object: self)
                NotificationCenter.default.post(name: .UpdatedArtists, object: self)
            })
        }
        queue.addOperations([ckOperation, ckAuthOperation, ckRegisterOperation, localAuthOperation], waitUntilFinished: false)
        
        return true
    }
    
    @objc func ckDataChange() {
        UserDefaults.standard.removeObject(forKey: "userRecordID")
    }

    @objc func actOnClosedPrompt() {
        if (window?.rootViewController as! UITabBarController).selectedIndex == 1 {
             (window?.rootViewController as! UITabBarController).selectedIndex = 0
        }
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


    private func application(application: UIApplication, didReceiveRemoteNotification notification : [NSObject : AnyObject]) {
        //print(notification)
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
