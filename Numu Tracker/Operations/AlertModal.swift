//
//  AlertModal.swift
//  Numu Tracker
//
//  Created by Brad Root on 12/19/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit

class AlertModal: AsyncOperation {
    let title: String!
    let button: String!
    let message: String!

    init(title: String, button: String, message: String) {
        self.title = title
        self.button = button
        self.message = message
    }

    override func main() {
        let alertView = NumuAlertView()
        alertView.providesPresentationContextTransitionStyle = true
        alertView.definesPresentationContext = true
        alertView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        alertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alertView.modalPresentationCapturesStatusBarAppearance = true
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertView, animated: true, completion: nil)
                alertView.titleText = self.title
                alertView.buttonText = self.button
                alertView.messageText = self.message
            }
        }
        self.state = .isFinished
    }

    func present() {
        self.qualityOfService = .userInitiated
        OperationQueue.main.addOperation(self)
    }
}
