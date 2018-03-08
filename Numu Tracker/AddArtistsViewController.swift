//
//  AddArtistsViewController.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/16/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit
import MediaPlayer
import Crashlytics

class AddArtistsViewController: UIViewController {


    @IBOutlet weak var addFromAppleMusic: UIButton!
    @IBAction func addFromAppleMusicPress(_ sender: AnyObject) {
        if (defaults.bool(forKey: "logged")) {
            self.addArtistsActivity.startAnimating()
            addFromAppleMusic.isHidden = true
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.runImportArtists()
                } else {
                    self.displayError()
                }
            }
        } else {
            if (UIDevice().screenType == UIDevice.ScreenType.iPhone4) {
                let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LogRegPromptSmall") as! UINavigationController
                DispatchQueue.main.async {
                    self.present(loginViewController, animated: true, completion: nil)
                }
            } else {
                let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LogRegPrompt") as! UINavigationController
                DispatchQueue.main.async {
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
            /*
             let controller = UIAlertController(title: "Apple Music Import", message: "Please log in first.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
             */
        }

    }

    @IBOutlet weak var addArtistsActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white

        addFromAppleMusic.backgroundColor = UIColor.clear
        addFromAppleMusic.layer.cornerRadius = 5
        addFromAppleMusic.layer.borderWidth = 1
        addFromAppleMusic.layer.borderColor = UIColor.gray.cgColor




        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    func runImportArtists() {


        let query = MPMediaQuery.artists()
        var artists_found: [String] = []
        query.groupingType = MPMediaGrouping.artist
        if let items = query.items {
            for artist in items {
                if let artist_name = artist.artist {
                    artists_found += [artist_name]
                }
            }
        }
        let uniques = Array(Set(artists_found))


        DispatchQueue.global(qos: .background).async(execute: {
            JSONClient.sharedClient.postArtists(artists: uniques) { success in
                DispatchQueue.main.async(execute: {
                    self.addArtistsActivity.stopAnimating()
                    self.addFromAppleMusic.isHidden = false
                    if (success == "Success") {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: updatedArtistsNotificationKey), object: self)
                        let controller = UIAlertController(title: "Success", message: "Your artists have been imported. Please allow several minutes for all artists to appear.", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(controller, animated: true, completion: nil)

                        Answers.logCustomEvent(withName: "AM Artist Import", customAttributes: ["Artists":uniques.count])

                    } else {
                        let controller = UIAlertController(title: "Error", message: "An error occurred which prevented artists from being imported.", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(controller, animated: true, completion: nil)

                    }
                })
            }
        })
    }

    func displayError() {
        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }

        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }


}
