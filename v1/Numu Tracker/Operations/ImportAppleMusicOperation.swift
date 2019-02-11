//
//  ImportAppleMusicOperation.swift
//  Numu Tracker
//
//  Created by Brad Root on 9/25/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit
import Crashlytics

class ImportAppleMusicOperation: AsyncOperation {

    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    var artistsImported: Int = 0

    override func main() {
        print("Running ImportAppleMusicOperation...")
        if !defaults.logged {
            self.state = .isFinished
            return
        }

        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.runImportArtists()
            } else {
                self.displayAMError()
                self.state = .isFinished
            }
        }
    }

    func runImportArtists() {
        // Build list of artists to be imported.
        let query = MPMediaQuery.artists()
        var artistsFound: [String] = []
        query.groupingType = .artist
        if let items = query.items {
            for artist in items {
                if let artistName = artist.artist {
                    artistsFound += [artistName]
                }
            }
        }
        let uniques = Array(Set(artistsFound))
        let json = ["artists": uniques]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

            // create post request
            let url = URL(string: "https://www.numutracker.com/v2/json.php?import")!
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"

            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            dataTask = session.dataTask(with: request as URLRequest) {[unowned self] (data, _, error) in
                guard let data = data else { return }
                do {
                    if let returnedJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let success = returnedJSON["success"] as? Int {
                            self.artistsImported = success
                            NumuReviewHelper.incrementAndAskForReview()
                            DispatchQueue.main.async(execute: {
                                self.displaySuccessMessage()
                                NotificationCenter.default.post(name: .UpdatedArtists, object: nil)
                                NotificationCenter.default.post(name: .LoggedIn, object: nil)
                                Answers.logCustomEvent(withName: "AM Artist Import")
                            })
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                print(self.artistsImported)
                self.state = .isFinished
            }

            dataTask?.resume()

        } catch {
            print(error.localizedDescription)
            self.state = .isFinished
        }

    }

    func displaySuccessMessage() {
        AlertModal(
            title: "Success",
            button: "Groovy",
            message: "Your artists have been imported. "
                + "Please wait several minutes for all artists "
                + "to appear in your collection."
        ).present()
    }

    func displayAMError() {
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "We cannot access your Apple Music artists because access has been denied to Numu." +
                " Please go to General -> Privacy -> Media & Apple Music to enable Numu's access."
        default:
            error = "Unknown error"
        }
        DispatchQueue.main.async {
            AlertModal(
                title: "Error",
                button: "Oh no",
                message: error
            ).present()
        }
        self.state = .isFinished
    }
}
