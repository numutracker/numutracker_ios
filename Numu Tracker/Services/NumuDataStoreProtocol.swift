//
//  ServiceProtocols.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

protocol NumuDataStoreProtocol {
    // MARK: - Artist
    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)

    // MARK: - Release
    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)

    // MARK: - User
    func createUser(userToCreate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func fetchUser(completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
    func updateUser(userToUpdate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void)

    // MARK: - User Imports
    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping (StorageResult?, StorageError?) -> Void)
}

enum StorageError: Error {
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
}
