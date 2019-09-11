//
//  LoginSpotifyViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import SpotifyLogin

class LoginSpotifyViewController: UIViewController {

    var loginButton: UIButton?
    @IBAction func closeButtonAction(_ sender: Any) {
        NotificationCenter.default.post(name: .CancelledSpotifyLogin, object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }

        // Do any additional setup after loading the view.

        self.title = "Spotify Login"

        let button = SpotifyLoginButton(viewController: self, scopes: [.userLibraryRead,
                                                                       .userFollowRead,
                                                                       .userReadTop])

        self.view.addSubview(button)

        self.loginButton = button

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessful),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton?.center = self.view.center
    }

    @objc func loginSuccessful() {
        print("Spotify Login Successful")
        defaults.enabledSpotify = true
        self.dismiss(animated: true, completion: nil)
    }

}
