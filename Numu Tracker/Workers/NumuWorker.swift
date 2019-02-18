//
//  NumuWorker.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuWorker {
    var localStorage: NumuStorageProtocol
    var remoteStorage: NumuAPIProtocol

    init(localStorage: NumuStorageProtocol, remoteStorage: NumuAPIProtocol) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }

    func fetchArtists(sinceDateUpdated: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        // First try to fetch from local storage
        self.localStorage.fetchArtists(sinceDateUpdated: sinceDateUpdated) { (artists, error) in
            if error == nil, !artists.isEmpty {
                completionHandler(artists, nil)
            }
        }
        // Then try to fetch from remote storage
        self.remoteStorage.fetchArtists(sinceDateUpdated: sinceDateUpdated) { (artists, error) in
            if error == nil, !artists.isEmpty {
                self.localStorage.createArtists(artistsToCreate: artists, completionHandler: { (artists, _) in
                    completionHandler(artists, nil)
                })
            }
        }
    }

//    func updateArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchReleases(sinceDateUpdated: Date?, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchReleases(forArtist: Artist, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
//        <#code#>
//    }
//
//    func updateRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
//        <#code#>
//    }
//
//    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
//        <#code#>
//    }

}

