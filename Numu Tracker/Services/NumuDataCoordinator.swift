//
//  NumuWorker.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class NumuDataCoordinator: NumuDataStoreProtocol {
    var localStorage: NumuDataStoreProtocol
    var remoteStorage: NumuDataStoreProtocol

    init(localStorage: NumuDataStoreProtocol, remoteStorage: NumuDataStoreProtocol) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }

    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        // First try to fetch from local storage
        print("Trying local storage...")
        self.localStorage.fetchUserArtists(sinceDateUpdated: sinceDateUpdated, offset: offset) { (result, error) in
            guard let artists = result!.items as? [Artist], !artists.isEmpty else {
                print("Trying remote storage...")
                self.remoteStorage.fetchUserArtists(sinceDateUpdated: sinceDateUpdated, offset: offset) { (result, error) in
                    if error == nil, let userArtists = result?.items as? [Artist] {
                        self.localStorage.createUserArtists(artistsToCreate: userArtists, completionHandler: { (_, _) in
                            print("Saved to local storage...")
                        })
                    }
                    completionHandler(result, error)
                }
                return
            }
            completionHandler(result, error)
        }
    }

    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func createUser(userToCreate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func fetchUser(completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func updateUser(userToUpdate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("Not implemented...")
    }

}
