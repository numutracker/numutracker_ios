//
//  ViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/5/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print(NumuCredential.shared.getV2Details())

        NumuCredential.shared.storeCredential(username: "test@test.com", password: "TestingP@ssword")

        if let URL = URL(string: "https://api.numutracker.com/v3/user/releases/unlistened") {
            let task = URLSession.shared.dataTask(with: URL) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return
                }
                do {
                    let response = try JSONDecoder().decode(NumuAPIResponse.self, from: dataResponse)

                    guard let releases = response.result?.userReleases else { return }

                    for release in releases {
                        print(release.artistNames, release.title)
                    }

                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            task.resume()
        }

    }

}
