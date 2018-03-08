//
//  NotificationsViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/24/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import UserNotifications
import Crashlytics

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificationStatusLabel: UILabel!
    @IBOutlet weak var thirtyDaysButtonView: UIView!
    @IBOutlet weak var oneYearButtonView: UIView!
    @IBOutlet weak var thirtyDaysTitleLabel: UILabel!
    @IBOutlet weak var oneYearTitleLabel: UILabel!
    @IBOutlet weak var thirtyDaysCostLabel: UILabel!
    @IBOutlet weak var oneYearCostLabel: UILabel!
    @IBOutlet weak var thirtyDaysLineView: UIView!
    @IBOutlet weak var oneYearLineView: UIView!

    //var thirtyDaysProduct: SKProduct = SKProduct()
    //var oneYearProduct: SKProduct = SKProduct()

    @IBAction func newReleased(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "newReleased")
    }
    @IBOutlet weak var newReleased: UISwitch!

    @IBAction func newAnnouncements(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "newAnnouncements")
    }
    @IBOutlet weak var newAnnouncements: UISwitch!

    @IBAction func moreReleases(_ sender: UISwitch) {
        self.notificationsSwitch(state: sender.isOn, type: "moreReleases")
    }
    @IBOutlet weak var moreReleases: UISwitch!

    func notificationsSwitch(state: Bool, type: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // actions based on whether notifications were authorized or not
            guard granted else { return }
            defaults.set(state, forKey: type)

            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /*

        // Notification payments disabled in 1.0.1

        self.updateSubLabel()

        thirtyDaysButtonView.layer.cornerRadius = 10.0
        thirtyDaysButtonView.clipsToBounds = true
        oneYearButtonView.layer.cornerRadius = 10.0
        oneYearButtonView.clipsToBounds = true

        oneYearLineView.layer.shadowColor = UIColor.shadow.cgColor
        oneYearLineView.layer.shadowOpacity = 0.9
        oneYearLineView.layer.shadowOffset = CGSize.zero
        oneYearLineView.layer.shadowRadius = 4
        oneYearLineView.layer.shouldRasterize = true

        thirtyDaysLineView.layer.shadowColor = UIColor.shadow.cgColor
        thirtyDaysLineView.layer.shadowOpacity = 0.9
        thirtyDaysLineView.layer.shadowOffset = CGSize.zero
        thirtyDaysLineView.layer.shadowRadius = 4
        thirtyDaysLineView.layer.shouldRasterize = true

        let thirtyDaysTap = UILongPressGestureRecognizer(target: self, action: #selector(self.thirtyDaysSubTapped))
        thirtyDaysTap.minimumPressDuration = 0
        thirtyDaysButtonView.addGestureRecognizer(thirtyDaysTap)

        let oneYearTap = UILongPressGestureRecognizer(target: self, action: #selector(self.oneYearSubTapped))
        oneYearTap.minimumPressDuration = 0
        oneYearButtonView.addGestureRecognizer(oneYearTap)

        self.newReleased.isEnabled = false
        self.newAnnouncements.isEnabled = false
        self.moreReleases.isEnabled = false


            */

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateSubLabel),
                                               name: .LoggedIn,
                                               object: nil)

        // Do any additional setup after loading the view.

         if defaults.logged {

            if defaults.newReleased {
                self.newReleased.isOn = true
                self.notificationsSwitch(state: true, type: "newReleased")
            }
            if defaults.newAnnouncements {
                self.newAnnouncements.isOn = true
                self.notificationsSwitch(state: true, type: "newAnnouncements")
            }
            if defaults.moreReleases {
                self.moreReleases.isOn = true
                self.notificationsSwitch(state: true, type: "moreReleases")
            }
        } else {
            self.newReleased.isEnabled = false
            self.newAnnouncements.isEnabled = false
            self.moreReleases.isEnabled = false
        }

        Answers.logCustomEvent(withName: "Notification Screen", customAttributes: nil)

        /*
        SwiftyStoreKit.retrieveProductsInfo(["com.numutracker.oneMonthNotifications"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                //print("Product: \(product.localizedDescription), \(product.localizedTitle), price: \(priceString)")
                self.thirtyDaysTitleLabel.text = product.localizedTitle
                self.thirtyDaysCostLabel.text = priceString
                self.thirtyDaysProduct = product

            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }

        SwiftyStoreKit.retrieveProductsInfo(["com.numutracker.oneYearNotifications"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                //print("Product: \(product.localizedDescription), \(product.localizedTitle), price: \(priceString)")
                self.oneYearTitleLabel.text = product.localizedTitle
                self.oneYearCostLabel.text = priceString
                self.oneYearProduct = product
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }

        */

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    @objc func thirtyDaysSubTapped(gesture: UITapGestureRecognizer) {

        if gesture.state == .began {
             //print("Touching Thirty Days")
            thirtyDaysButtonView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else if gesture.state == .ended { // optional for touch up event catching
            //print("Touch Up Thirty Days")
            thirtyDaysButtonView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            if (!defaults.logged) {
                if (UIDevice().screenType == UIDevice.ScreenType.iPhone4) {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPromptSmall") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                } else {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                }
            } else {

                SwiftyStoreKit.purchaseProduct(thirtyDaysProduct, quantity: 1, atomically: false) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        DispatchQueue.global(qos: .background).async(execute: {
                            let success = JSONClient.sharedClient.processPurchase(username: defaults.username!, password: defaults.password!, purchased: product.productId)
                            DispatchQueue.main.async(execute: {
                                if (success == "1") {
                                    if product.needsFinishTransaction {
                                        SwiftyStoreKit.finishTransaction(product.transaction)
                                    }
                                    self.updateSubLabel()
                                    //print("Purchase Success: \(product.productId)")
                                    Answers.logPurchase(withPrice: self.thirtyDaysProduct.price, currency: self.thirtyDaysProduct.priceLocale.currencyCode, success: true, itemName: "30 Days Notes", itemType: "Notifications", itemId: nil, customAttributes: nil)
                                }
                            })
                        })
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        }
                    }
                }
            }
        }

    }

    @objc func oneYearSubTapped(gesture: UITapGestureRecognizer) {


        if gesture.state == .began {
            //print("Touching One Year")
            oneYearButtonView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else if gesture.state == .ended { // optional for touch up event catching
            //print("Touch Up One Year")
            oneYearButtonView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            if (!defaults.logged) {
                if (UIDevice().screenType == UIDevice.ScreenType.iPhone4) {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPromptSmall") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                } else {
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
                    DispatchQueue.main.async {
                        self.present(loginViewController, animated: true, completion: nil)
                    }
                }
            } else {

                SwiftyStoreKit.purchaseProduct(oneYearProduct, quantity: 1, atomically: false) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        DispatchQueue.global(qos: .background).async(execute: {
                            let success = JSONClient.sharedClient.processPurchase(username: defaults.username!, password: defaults.password!, purchased: product.productId)

                            DispatchQueue.main.async(execute: {
                                if (success == "1") {
                                    if product.needsFinishTransaction {
                                        SwiftyStoreKit.finishTransaction(product.transaction)
                                    }
                                    self.updateSubLabel()
                                    print("Purchase Success: \(product.productId)")
                                    Answers.logPurchase(withPrice: self.oneYearProduct.price, currency: self.oneYearProduct.priceLocale.currencyCode, success: true, itemName: "One Year Notes", itemType: "Notifications", itemId: nil, customAttributes: nil)
                                }
                            })
                        })
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        }
                    }
                }
            }
        }

    }
    */
    @objc func updateSubLabel() {
        if defaults.logged {
            if defaults.newReleased {
                self.newReleased.isOn = true
                self.notificationsSwitch(state: true, type: "newReleased")
            }
            if defaults.newAnnouncements {
                self.newAnnouncements.isOn = true
                self.notificationsSwitch(state: true, type: "newAnnouncements")
            }
            if defaults.moreReleases {
                self.moreReleases.isOn = true
                self.notificationsSwitch(state: true, type: "moreReleases")
            }

        } else {

            self.newReleased.isEnabled = false
            self.newAnnouncements.isEnabled = false
            self.moreReleases.isEnabled = false

        }
        /*
        if (defaults.logged)  {
        DispatchQueue.global(qos: .background).async(execute: {
        let sub_status = JSONClient.sharedClient.getSubStatus(username: defaults.username!, password: defaults.password!)
            DispatchQueue.main.async(execute: {
                if (sub_status[0] == "0") {
                    self.notificationStatusLabel.text = "You are not subscribed. Add time below."
                    self.newReleased.isEnabled = false
                    self.newAnnouncements.isEnabled = false
                    self.moreReleases.isEnabled = false
                    defaults.set(false, forKey: "newReleased")
                    defaults.set(false, forKey: "newAnnouncements")
                    defaults.set(false, forKey: "moreReleases")
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let end_date = formatter.date(from: sub_status[1])
                    let now_date = formatter.date(from: sub_status[2])
                    let days_left = self.daysBetween(start: now_date!, end: end_date!)
                    self.notificationStatusLabel.text = "You have \(days_left) days remaining in your subscription."
                    self.newReleased.isEnabled = true
                    self.newAnnouncements.isEnabled = true
                    self.moreReleases.isEnabled = true
                    if defaults.newReleased {
                        self.newReleased.isOn = true
                        self.notificationsSwitch(state: true, type: "newReleased")
                    }
                    if defaults.newAnnouncements {
                        self.newAnnouncements.isOn = true
                        self.notificationsSwitch(state: true, type: "newAnnouncements")
                    }
                    if defaults.moreReleases {
                        self.moreReleases.isOn = true
                        self.notificationsSwitch(state: true, type: "moreReleases")
                    }
                }
            })
        })
        } else {
            self.notificationStatusLabel.text = "You are not subscribed. Add time below."
            self.newReleased.isEnabled = false
            self.newAnnouncements.isEnabled = false
            self.moreReleases.isEnabled = false
            defaults.set(false, forKey: "newReleased")
            defaults.set(false, forKey: "newAnnouncements")
            defaults.set(false, forKey: "moreReleases")
        }
         */
    }

    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
