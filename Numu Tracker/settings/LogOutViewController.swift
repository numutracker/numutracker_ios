//
//  LogOutViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/22/17.
//  Copyright © 2017 Numu Tracker. All rights reserved.
//

import UIKit
import UserNotifications
import PusherSwift
import Crashlytics

extension UIColor {
    static let shadow = UIColor(red: 28/255, green: 202/255, blue: 241/255, alpha: 1)
    static let bg = UIColor(red: 48/255, green: 156/255, blue: 172/255, alpha: 1)
}

class LogOutViewController: UIViewController {

    @IBOutlet weak var dividingLineView1: UIView!
    @IBOutlet weak var dividingLineView2: UIView!
    @IBOutlet weak var dividingLineView3: UIView!
    @IBOutlet weak var dividingLineView4: UIView!
    @IBOutlet weak var dividingLineView5: UIView!

    @IBOutlet weak var artistsListenedLabel: UILabel!
    @IBOutlet weak var artistsFollowedLabel: UILabel!
    @IBOutlet weak var releasesListenedLabel: UILabel!
    @IBOutlet weak var releasesFollowedLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!

    var artistsListenedInt: Double = 0 {
        didSet {
            let stringFormat = String(format: "%.0f", artistsListenedInt)
            self.artistsListenedLabel.text = "\(stringFormat)"
        }
    }
    var artistsFollowedInt: Double = 0 {
        didSet {
            let stringFormat = String(format: "%.0f", artistsFollowedInt)
            self.artistsFollowedLabel.text = "\(stringFormat)"
        }
    }
    var releasesListenedInt: Double = 0 {
        didSet {
            let stringFormat = String(format: "%.0f", releasesListenedInt)
            self.releasesListenedLabel.text = "\(stringFormat)"
        }
    }
    var releasesFollowedInt: Double = 0 {
        didSet {
            let stringFormat = String(format: "%.0f", releasesFollowedInt)
            self.releasesFollowedLabel.text = "\(stringFormat)"
        }
    }
    var completionFloat: Double = 0.0 {
        didSet {
            let stringFormat = String(format: "%.1f", completionFloat)
            self.completionLabel.text = "\(stringFormat)%"
        }
    }

    var artistsListenedFinalInt: Double = 0.0
    var artistsFollowedFinalInt: Double = 0.0
    var releasesListenedFinalInt: Double = 0.0
    var releasesFollowedFinalInt: Double = 0.0
    var completionFinalFloat: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get user stats...
        self.getUserStats()

        if defaults.logged {
            if let user = defaults.username {
                Answers.logCustomEvent(withName: "User Stats", customAttributes: ["User":user])
            }
        }

        // Do any additional setup after loading the view.

        dividingLineView1.layer.shadowColor = UIColor.shadow.cgColor
        dividingLineView1.layer.shadowOpacity = 0.9
        dividingLineView1.layer.shadowOffset = .zero
        dividingLineView1.layer.shadowRadius = 4
        dividingLineView1.layer.shouldRasterize = true

        dividingLineView2.layer.shadowColor = UIColor.shadow.cgColor
        dividingLineView2.layer.shadowOpacity = 0.9
        dividingLineView2.layer.shadowOffset = .zero
        dividingLineView2.layer.shadowRadius = 4
        dividingLineView2.layer.shouldRasterize = true

        dividingLineView3.layer.shadowColor = UIColor.shadow.cgColor
        dividingLineView3.layer.shadowOpacity = 0.9
        dividingLineView3.layer.shadowOffset = .zero
        dividingLineView3.layer.shadowRadius = 4
        dividingLineView3.layer.shouldRasterize = true

        dividingLineView4.layer.shadowColor = UIColor.shadow.cgColor
        dividingLineView4.layer.shadowOpacity = 0.9
        dividingLineView4.layer.shadowOffset = .zero
        dividingLineView4.layer.shadowRadius = 4
        dividingLineView4.layer.shouldRasterize = true

        dividingLineView5.layer.shadowColor = UIColor.shadow.cgColor
        dividingLineView5.layer.shadowOpacity = 0.9
        dividingLineView5.layer.shadowOffset = .zero
        dividingLineView5.layer.shadowRadius = 4
        dividingLineView5.layer.shouldRasterize = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnClosedPrompt), name: .ClosedLogRegPrompt, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnLoggedInNotification), name: .LoggedIn, object: nil)

        let add = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))

        navigationItem.rightBarButtonItem = add
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func getUserStats() {
        if defaults.logged {
            let user = defaults.username!
            DispatchQueue.global(qos: .background).async(execute: {
                let json = SearchClient.sharedClient.getUserStats(username: user)
                DispatchQueue.main.async(execute: {

                    self.artistsListenedFinalInt = json["total_list_artists_unfilt"].double!
                    self.artistsFollowedFinalInt = json["total_follows"].double!
                    self.releasesListenedFinalInt = json["total_listens_unfilt"].double!
                    self.releasesFollowedFinalInt = json["total_rel_fol"].double!
                    self.completionFinalFloat = json["percentage"].double!

                    self.startTimer()
                })

            })
        } else {
            // Nada
        }
    }

    @objc func startTimer() {
        var increment: Bool = false

        if self.artistsListenedFinalInt > self.artistsListenedInt {
            self.artistsListenedInt = self.artistsListenedInt + (self.artistsListenedFinalInt/150)
            increment = true
        } else {
            self.artistsListenedInt = self.artistsListenedFinalInt
        }

        if self.artistsFollowedFinalInt > self.artistsFollowedInt {
            self.artistsFollowedInt = self.artistsFollowedInt + (self.artistsFollowedFinalInt/150)
            increment = true
        } else {
            self.artistsFollowedInt = self.artistsFollowedFinalInt
        }

        if self.releasesListenedFinalInt > self.releasesListenedInt {
            self.releasesListenedInt = self.releasesListenedInt + (self.releasesListenedFinalInt/150)
            increment = true
        } else {
            self.releasesListenedInt = self.releasesListenedFinalInt
        }

        if self.releasesFollowedFinalInt > self.releasesFollowedInt {
            self.releasesFollowedInt = self.releasesFollowedInt + (self.releasesFollowedFinalInt/150)
            increment = true
        } else {
            self.releasesFollowedInt = self.releasesFollowedFinalInt
        }

        if self.completionFinalFloat > self.completionFloat {
            self.completionFloat = self.completionFloat + (self.completionFinalFloat/150)
            increment = true
        } else {
            self.completionFinalFloat = self.completionFloat
        }

        if increment {
            _ = Timer.scheduledTimer(timeInterval: 0.005, target: self,
                                     selector: #selector(startTimer), userInfo: nil, repeats: false)
        }
    }

    @objc func logOut() {
        defaults.newReleased = false
        defaults.newAnnouncements = false
        defaults.moreReleases = false
        UIApplication.shared.registerForRemoteNotifications()
        defaults.username = nil
        defaults.password = nil
        defaults.logged = false
        
        // Remove credentials from URLCredentialStorage
        NumuCredential.removeCredential()
                
        NotificationCenter.default.post(name: .LoggedOut, object: self)
        NotificationCenter.default.post(name: .UpdatedArtists, object: self)
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !defaults.logged {
            if UIDevice().screenType == .iPhone4 {
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
        }
    }

    @objc func actOnClosedPrompt() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @objc func actOnLoggedInNotification() {
        getUserStats()
        //self.logOutButton.setTitle("Log Out", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
