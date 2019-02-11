//
//  ViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let releasesEngine = NumuAPIReleases(releaseType: .unlistened)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NumuAPICredential.shared.storeCredential(username: "test@test.com", password: "TestingP@ssword")
        //NumuAPICredential.shared.removeCredential()

        self.releasesEngine.get {
            self.printreleases()
            if self.releasesEngine.isMoreAvailable() {
                self.releasesEngine.getMore {
                    self.printreleases()
                    if self.releasesEngine.isMoreAvailable() {
                        self.releasesEngine.getMore {
                            self.printreleases()
                        }
                    }
                }
            }
        }

    }

    func printreleases() {
        for release in self.releasesEngine.releases {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            let date = dateFormatter.string(from: release.dateRelease)
            print(date, "-", release.artistNames, "-", release.title)
        }
    }

}
