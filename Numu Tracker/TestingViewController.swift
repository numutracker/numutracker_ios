//
//  TestingViewController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/13/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let cdWorker = NumuWorker(numuStore: CoreDataStore())

        let artist = Artist.init(
            mbid: UUID(uuidString: "00d8d4c2-af97-47c1-b205-cb71937be54d")!,
            name: "blah 2",
            nameSort: "blah 2",
            primaryArtUrl: URL(string: "http://wwww.numutracker.com")!,
            largeArtUrl: URL(string: "http://wwww.numutracker.com")!,
            dateUpdated: Date(timeIntervalSince1970: 0),
            dateFollowed: nil,
            following: true
        )

        cdWorker.numuStore.createArtist(artistToCreate: artist) { (artist, error) in
            print(artist, error)
        }

        cdWorker.numuStore.fetchArtists(sinceDateUpdated: nil) { (artists, error) in
            print(artists, error)
        }

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
