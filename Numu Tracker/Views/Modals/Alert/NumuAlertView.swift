//
//  NumuAlertView.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/3/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class NumuAlertView: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!

    var titleText: String?
    var messageText: String?
    var buttonText: String?

    @IBAction func acceptButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }

    func setupView() {
        alertView.layer.cornerRadius = 15
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.setTitleColor(.white, for: .highlighted)

        if !UIAccessibility.isReduceTransparencyEnabled {
            alertView.backgroundColor = .clear

            let detailBlurEffect = UIBlurEffect(style: .dark)
            let detailBlurEffectView = UIVisualEffectView(effect: detailBlurEffect)
            //always fill the view
            detailBlurEffectView.frame = alertView.bounds
            detailBlurEffectView.layer.cornerRadius = 15
            detailBlurEffectView.clipsToBounds = true
            detailBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            alertView.insertSubview(detailBlurEffectView, at: 0)

            self.view.backgroundColor = .clear

            let bgBlurEffect = UIBlurEffect(style: .regular)
            let bgBlurEffectView = UIVisualEffectView(effect: bgBlurEffect)
            //always fill the view
            bgBlurEffectView.frame = self.view.bounds
            bgBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.insertSubview(bgBlurEffectView, at: 0)

        } else {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }

        if let message = self.messageText {
            self.messageLabel.text = message
        }

        if let title = self.titleText {
            self.titleLabel.text = title
        }

        if let button = self.buttonText {
            self.acceptButton.setTitle(button, for: .normal)
        }
    }

    func animateView() {
        alertView.alpha = 0
        self.alertView.frame.origin.y += 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0
            self.alertView.frame.origin.y -= 50
        })
    }

}
