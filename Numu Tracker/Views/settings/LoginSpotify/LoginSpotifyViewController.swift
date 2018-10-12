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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Spotify Login"
        
        let button = SpotifyLoginButton(viewController: self, scopes: [.userLibraryRead])
        
        self.view.addSubview(button)
        
        self.loginButton = button
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton?.center = self.view.center
    }

}
