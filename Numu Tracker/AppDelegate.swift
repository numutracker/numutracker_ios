//
//  AppDelegate.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit
import CoreData
import PushNotifications
import SpotifyLogin

let defaults = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let pushNotifications = PushNotifications.shared

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Pusher Beams development instanceId: "088d60ee-7163-47af-9f40-89aa54b1babb"
        self.pushNotifications.start(instanceId: "088d60ee-7163-47af-9f40-89aa54b1babb")
        self.pushNotifications.registerForRemoteNotifications()
        // try? self.pushNotifications.subscribe(interest: "debug-hello")

        // Override point for customization after application launch.
        let redirectURL: URL = URL(string: "numu://")!
        SpotifyLogin.shared.configure(clientID: "SPOTIFY_CLIENT_ID", clientSecret: "SPOTIFY_CLIENT_SECRET", redirectURL: redirectURL)

        NumuCredential.shared.storeCredential(username: "test@test.com", password: "TestingP@ssword")

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { (_) in }
        return handled
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
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Pusher Beams

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
    }

}
