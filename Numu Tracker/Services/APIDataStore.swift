//
//  APIDataStore.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation

class APIDataStore: NumuAPIProtocol {

    func createArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping ([ArtistImport], NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchArtists(sinceDateUpdated: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchReleases(sinceDateUpdated: Date?, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchReleases(forArtist: Artist, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        <#code#>
    }

    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        <#code#>
    }

}
