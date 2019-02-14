//
//  StorageController.swift
//  Numu Tracker
//
//  Created by Brad Root on 2/13/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation
import CoreData

class StorageController {

    fileprivate func printPersistedArtists() {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<ArtistMO> = ArtistMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        let results = try? context.fetch(request)
        if let results = results {
            for artist in results {
                print(artist.name ?? "what", artist.following, artist.releases?.count)
            }
        }
    }

    fileprivate func printPersistedReleases() {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<ReleaseMO> = ReleaseMO.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "dateRelease", ascending: false),
            NSSortDescriptor(key: "artistNames", ascending: true)
        ]
        let results = try? context.fetch(request)
        if let results = results {
            for release in results {
                print(release.dateRelease, release.artistNames, release.title, release.artists?.count)
            }
        }
    }

    fileprivate func getArtist(byMbid mbid: UUID) -> ArtistMO? {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<ArtistMO> = ArtistMO.fetchRequest()
        request.predicate = NSPredicate(format: "mbid = %@", mbid as CVarArg)
        let result = try? context.fetch(request)
        if let result = result, let artist = result.first {
            return artist
        }
        return nil
    }

    fileprivate func getRelease(byMbid mbid: UUID) -> ReleaseMO? {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<ReleaseMO> = ReleaseMO.fetchRequest()
        request.predicate = NSPredicate(format: "mbid = %@", mbid as CVarArg)
        let result = try? context.fetch(request)
        if let result = result, let release = result.first {
            return release
        }
        return nil
    }

    func updateArtistMO(artistMO: ArtistMO, apiArtist: NumuAPIArtist) {
        artistMO.following = apiArtist.userData?.following ?? false
        artistMO.dateFollowed = apiArtist.userData?.dateFollowed as NSDate?
        artistMO.name = apiArtist.name
        artistMO.mbid = apiArtist.mbid
        artistMO.nameSort = apiArtist.sortName
        artistMO.primaryArtUrl = apiArtist.primaryArtUrl
        artistMO.dateFollowed = apiArtist.userData?.dateFollowed as NSDate?
        artistMO.dateUpdated = apiArtist.dateUpdated! as NSDate
    }

    func updateReleaseMO(releaseMO: ReleaseMO, apiRelease: NumuAPIRelease) {
        let context = AppDelegate.viewContext
        releaseMO.mbid = apiRelease.mbid
        releaseMO.artistNames = apiRelease.artistNames
        releaseMO.dateFollowed = apiRelease.userData?.dateFollowed as NSDate?
        releaseMO.dateListened = apiRelease.userData?.dateListened as NSDate?
        releaseMO.dateUpdated = apiRelease.dateUpdated as NSDate
        releaseMO.dateRelease = apiRelease.dateRelease as NSDate
        releaseMO.listened = apiRelease.userData?.listened ?? false
        releaseMO.primaryArtUrl = apiRelease.primaryArtUrl
        releaseMO.title = apiRelease.title
        releaseMO.following = apiRelease.userData?.following ?? false

        for apiArtist in apiRelease.artists {
            if let persistedArtist = self.getArtist(byMbid: apiArtist.mbid) {
                releaseMO.addToArtists(persistedArtist)
            } else {
                let persistedArtist = ArtistMO(context: context)
                self.updateArtistMO(artistMO: persistedArtist, apiArtist: apiArtist)
                releaseMO.addToArtists(persistedArtist)
            }
        }
    }

    func populateReleases() {
        let releaseEngine: NumuAPIReleases = NumuAPIReleases(releaseType: .released)
        let context = AppDelegate.viewContext
        releaseEngine.get {
            for release in releaseEngine.releases {
                if let persistedRelease = self.getRelease(byMbid: release.mbid) {
                    self.updateReleaseMO(releaseMO: persistedRelease, apiRelease: release)
                } else {
                    let persistedRelease = ReleaseMO(context: context)
                    self.updateReleaseMO(releaseMO: persistedRelease, apiRelease: release)
                }
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
            self.printPersistedReleases()
        }
    }

    func populateArtists() {
        let artistEngine: NumuAPIArtists = NumuAPIArtists()
        let context = AppDelegate.viewContext
        artistEngine.get {
            for artist in artistEngine.artists {
                if let persistedArtist = self.getArtist(byMbid: artist.mbid) {
                    self.updateArtistMO(artistMO: persistedArtist, apiArtist: artist)
                } else {
                    let persistedArtist = ArtistMO(context: context)
                    self.updateArtistMO(artistMO: persistedArtist, apiArtist: artist)
                }
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
            self.printPersistedArtists()
        }
    }

}
