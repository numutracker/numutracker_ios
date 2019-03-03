//
//  ServiceProtocols.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

protocol NumuDataProtocol {
    func fetchArtists(sinceDateUpdated: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void)
    func updateArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void)

    func fetchReleases(sinceDateUpdated: Date?, completionHandler: @escaping ([Release], NumuStoreError?) -> Void)
    func fetchReleases(forArtist: Artist, completionHandler: @escaping ([Release], NumuStoreError?) -> Void)
    func updateRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void)

    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void)
    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void)
}

protocol NumuStorageProtocol: NumuDataProtocol {
    func createArtist(artistToCreate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void)
    func createArtists(artistsToCreate: [Artist], completionHandler: @escaping ([Artist], NumuStoreError?) -> Void)

    func createRelease(releaseToCreate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void)
    func createReleases(releasesToCreate: [Release], completionHandler: @escaping ([Release], NumuStoreError?) -> Void)

    func createUser(userToCreate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void)
}

protocol NumuAPIProtocol: NumuDataProtocol {
    func createArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping ([ArtistImport], NumuStoreError?) -> Void)
}

enum NumuStoreError: Error {
    case cannotFetch(String)
    case cannotCreate(String)
    case cannotUpdate(String)
    case cannotDelete(String)
}
