//
//  ImportAppleMusicViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import MediaPlayer
import Crashlytics

class ImportAppleMusicViewController: UIViewController {

    @IBOutlet weak var addFromAppleMusic: UIButton!
    @IBAction func addFromAppleMusicPress(_ sender: AnyObject) {
        addArtistsActivity.startAnimating()
        let importAMOperation = ImportAppleMusicOperation()
        let queue = OperationQueue()
        importAMOperation.qualityOfService = .userInteractive
        importAMOperation.completionBlock = {
            DispatchQueue.main.async {
                self.addArtistsActivity.stopAnimating()
            }
        }
        queue.addOperation(importAMOperation)
    }

    @IBOutlet weak var addArtistsActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
