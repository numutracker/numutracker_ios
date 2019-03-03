//
//  ServiceProtocols.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

protocol NumuDataProtocol {
    // MARK: - Artist
    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void)
    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping ([Artist], NumuStoreError?) -> Void)
    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void)
    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void)

    // MARK: - Release
    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void)
    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping ([Release], NumuStoreError?) -> Void)
    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping ([Release], NumuStoreError?) -> Void)
    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping ([Release], NumuStoreError?) -> Void)
    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void)

    // MARK: - User
    func createUser(userToCreate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void)
    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void)
    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void)

    // MARK: - User Imports
    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping ([ArtistImport], NumuStoreError?) -> Void)
}

enum NumuStoreError: Error {
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
}
