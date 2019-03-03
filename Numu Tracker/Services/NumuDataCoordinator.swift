//
//  NumuWorker.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuDataCoordinator {
    var localStorage: NumuDataProtocol
    var remoteStorage: NumuDataProtocol

    init(localStorage: NumuDataProtocol, remoteStorage: NumuDataProtocol) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }

//    func fetchArtists(sinceDateUpdated: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
//        // First try to fetch from local storage
//        self.localStorage.fetchArtists(sinceDateUpdated: sinceDateUpdated) { (artists, error) in
//            if error == nil, !artists.isEmpty {
//                completionHandler(artists, nil)
//            }
//        }
//        // Then try to fetch from remote storage
//        self.remoteStorage.fetchArtists(sinceDateUpdated: sinceDateUpdated) { (artists, error) in
//            if error == nil, !artists.isEmpty {
//                self.localStorage.createArtists(artistsToCreate: artists, completionHandler: { (artists, _) in
//                    completionHandler(artists, nil)
//                })
//            }
//        }
//    }

//    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func createUser(userToCreate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func fetchUser(completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func updateUser(userToUpdate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }
//
//    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
//        <#code#>
//    }

}

