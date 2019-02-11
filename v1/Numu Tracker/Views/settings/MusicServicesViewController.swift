//
//  MusicServicesViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/20/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import SpotifyLogin

class MusicServicesViewController: UIViewController {

    @IBOutlet weak var appleMusicSwitch: UISwitch!
    @IBOutlet weak var spotifySwitch: UISwitch!
    @IBOutlet weak var youTubeSwitch: UISwitch!
    @IBOutlet weak var soundCloudSwitch: UISwitch!

    @IBAction func appleMusicAction(_ sender: UISwitch) {
        self.serviceSwitch(state: !sender.isOn, type: "disabledAppleMusic")
    }
    @IBAction func spotifyAction(_ sender: UISwitch) {
        if sender.isOn {
            SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
                if error != nil, token == nil {
                    self?.showSpotifyLogin()
                } else {
                    self?.serviceSwitch(state: sender.isOn, type: "enabledSpotify")
                }
            }
        } else {
            self.serviceSwitch(state: false, type: "enabledSpotify")
        }
    }
    @IBAction func youTubeAction(_ sender: UISwitch) {
        self.serviceSwitch(state: sender.isOn, type: "enabledYouTube")
    }
    @IBAction func soundCloudAction(_ sender: UISwitch) {
        self.serviceSwitch(state: sender.isOn, type: "enabledSoundCloud")
        if sender.isOn {
            AlertModal(
                title: "Important Notice",
                button: "Oh, okay",
                message: "SoundCloud's iOS app is buggy, and the 'Search on SoundCloud' "
                        + "button will not work properly. I've notified SoundCloud and "
                        + "hopefully they will issue a fix."
            ).present()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSwitches()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(turnOnSpotify),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelSpotifyLogin),
                                               name: .CancelledSpotifyLogin,
                                               object: nil)
    }

    func setUpSwitches() {
        if defaults.disabledAppleMusic { appleMusicSwitch.isOn = false }
        if defaults.enabledSpotify { spotifySwitch.isOn = true }
        if defaults.enabledYouTube { youTubeSwitch.isOn = true }
        if defaults.enabledSoundCloud { soundCloudSwitch.isOn = true }
    }

    func serviceSwitch(state: Bool, type: String) {
        defaults.set(state, forKey: type)
    }

    @objc func turnOnSpotify() {
        self.serviceSwitch(state: true, type: "enabledSpotify")
    }

    @objc func cancelSpotifyLogin() {
        self.spotifySwitch.isOn = false
    }

    func showSpotifyLogin() {
        let spotifyLogin = LoginSpotifyViewController()
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(spotifyLogin, animated: true, completion: nil)
            }
        }
    }

}
