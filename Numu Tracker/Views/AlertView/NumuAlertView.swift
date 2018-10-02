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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }

    func setupView() {
        alertView.layer.cornerRadius = 15
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 0.2
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = 20
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.setTitleColor(.white, for: .highlighted)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
