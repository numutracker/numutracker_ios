//
//  ImportSpotifyViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 10/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import UIKit
import SpotifyLogin
import Spartan

class ImportSpotifyViewController: UIViewController {

    @IBOutlet weak var spotifyButton: NumuUIButton!
    @IBOutlet weak var importSpotifyIndicator: UIActivityIndicatorView!
    @IBAction func importSpotifyAction(_ sender: Any) {
        importSpotifyIndicator.startAnimating()
        let importSpotifyOperation = ImportSpotifyOperation()
        let queue = OperationQueue()
        importSpotifyOperation.qualityOfService = .userInteractive
        importSpotifyOperation.completionBlock = {
            DispatchQueue.main.async {
                self.importSpotifyIndicator.stopAnimating()
            }
        }
        queue.addOperation(importSpotifyOperation)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
