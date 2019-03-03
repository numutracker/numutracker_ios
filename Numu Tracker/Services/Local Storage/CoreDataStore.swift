//
//  CoreDataStore.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore: NumuDataProtocol {

    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = {
            let container = NSPersistentContainer(name: "Numu_Tracker")
            container.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        mainManagedObjectContext = persistentContainer.viewContext
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }

    deinit {
        self.saveContext()
    }

    fileprivate func saveContext () {
        if self.mainManagedObjectContext.hasChanges {
            do {
                try self.mainManagedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - User

    func createUser(userToCreate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let managedUser = ManagedUser(context: self.privateManagedObjectContext)
                let user = userToCreate
                managedUser.fromUser(user: userToCreate)
                try self.privateManagedObjectContext.save()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: 1,
                    resultsRemaining: 0,
                    items: [user])
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotCreate("Cannot create user with id \(String(describing: userToCreate.userId))"))
            }
        }
    }

    func fetchUser(completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
                let managedUser = try self.privateManagedObjectContext.fetch(fetchRequest).first
                let user = managedUser!.toUser()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: 1,
                    resultsRemaining: 0,
                    items: [user])
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotFetch("No user found"))
            }
        }
    }

    func updateUser(userToUpdate: User, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", userToUpdate.userId)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                if let managedUser = results.first {
                    do {
                        managedUser.fromUser(user: userToUpdate)
                        let user = managedUser.toUser()
                        try self.privateManagedObjectContext.save()
                        let result = StorageResult.init(
                            offset: 0,
                            resultsTotal: 1,
                            resultsRemaining: 0,
                            items: [user])
                        completionHandler(result, nil)
                    } catch {
                        completionHandler(nil, StorageError.cannotUpdate("Cannot update user with id \(String(describing: userToUpdate.userId))"))
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    StorageError.cannotUpdate("Cannot fetch release with mbid \(String(describing: userToUpdate.userId)) to update")
                )
            }
        }
    }

    // MARK: - Artists

    func createUserArtist(artistToCreate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", artistToCreate.mbid as CVarArg)
                if let managedArtist = try self.privateManagedObjectContext.fetch(fetchRequest).first {
                    managedArtist.fromArtist(artist: artistToCreate)
                } else {
                    let managedArtist = ManagedArtist(context: self.privateManagedObjectContext)
                    managedArtist.fromArtist(artist: artistToCreate)
                }
                let artist = artistToCreate
                try self.privateManagedObjectContext.save()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: 1,
                    resultsRemaining: 0,
                    items: [artist])
                completionHandler(result, nil)
            } catch {
                print(error)
                completionHandler(nil, StorageError.cannotCreate("Cannot create artist with mbid \(String(describing: artistToCreate.mbid))"))
            }
        }
    }

    func createUserArtists(artistsToCreate: [Artist], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                var artists: [Artist] = []
                for artistToCreate in artistsToCreate {
                    let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "mbid == %@", artistToCreate.mbid as CVarArg)
                    if let managedArtist = try self.privateManagedObjectContext.fetch(fetchRequest).first {
                        managedArtist.fromArtist(artist: artistToCreate)
                    } else {
                        let managedArtist = ManagedArtist(context: self.privateManagedObjectContext)
                        managedArtist.fromArtist(artist: artistToCreate)
                    }
                    artists.append(artistToCreate)
                }
                try self.privateManagedObjectContext.save()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: artists.count,
                    resultsRemaining: 0,
                    items: artists)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotCreate("Could not create artist batch"))
            }
        }
    }

    func fetchUserArtists(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "following == %@", NSNumber(value: true))
                let totalCount = try! self.privateManagedObjectContext.count(for: fetchRequest)
                fetchRequest.fetchLimit = 50
                fetchRequest.fetchOffset = offset
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let artists = results.map { $0.toArtist() }
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: totalCount,
                    resultsRemaining: totalCount - offset - artists.count,
                    items: artists)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotFetch("Cannot fetch artists"))
            }
        }
    }

    func updateUserArtist(artistToUpdate: Artist, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", artistToUpdate.mbid as CVarArg)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                if let managedArtist = results.first {
                    do {
                        managedArtist.fromArtist(artist: artistToUpdate)
                        let artist = managedArtist.toArtist()
                        try self.privateManagedObjectContext.save()
                        let result = StorageResult.init(
                            offset: 0,
                            resultsTotal: 1,
                            resultsRemaining: 0,
                            items: [artist])
                        completionHandler(result, nil)
                    } catch {
                        completionHandler(
                            nil,
                            StorageError.cannotUpdate("Cannot update artist with mbid \(String(describing: artistToUpdate.mbid))")
                        )
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    StorageError.cannotUpdate("Cannot fetch artist with mbid \(String(describing: artistToUpdate.mbid)) to update")
                )
            }
        }
    }

    // MARK: - Releases

    func createUserRelease(releaseToCreate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedRelease> = ManagedRelease.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", releaseToCreate.mbid as CVarArg)
                if let managedRelease = try self.privateManagedObjectContext.fetch(fetchRequest).first {
                    managedRelease.fromRelease(release: releaseToCreate)
                } else {
                    let managedRelease = ManagedRelease(context: self.privateManagedObjectContext)
                    managedRelease.fromRelease(release: releaseToCreate)
                }
                let release = releaseToCreate
                try self.privateManagedObjectContext.save()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: 1,
                    resultsRemaining: 0,
                    items: [release])
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotCreate("Cannot create release with mbid \(String(describing: releaseToCreate.mbid))"))
            }
        }
    }

    func createUserReleases(releasesToCreate: [Release], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                var releases: [Release] = []
                for releaseToCreate in releasesToCreate {
                    let fetchRequest: NSFetchRequest<ManagedRelease> = ManagedRelease.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "mbid == %@", releaseToCreate.mbid as CVarArg)
                    if let managedRelease = try self.privateManagedObjectContext.fetch(fetchRequest).first {
                        managedRelease.fromRelease(release: releaseToCreate)
                    } else {
                        let managedRelease = ManagedRelease(context: self.privateManagedObjectContext)
                        managedRelease.fromRelease(release: releaseToCreate)
                    }
                    releases.append(releaseToCreate)
                }
                try self.privateManagedObjectContext.save()
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: releases.count,
                    resultsRemaining: 0,
                    items: releases)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotCreate("Could not create release batch"))
            }
        }
    }

    func fetchUserReleases(sinceDateUpdated: Date?, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedRelease> = ManagedRelease.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "following == %@", NSNumber(value: true))
                let totalCount = try! self.privateManagedObjectContext.count(for: fetchRequest)
                fetchRequest.fetchLimit = 50
                fetchRequest.fetchOffset = offset
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let releases = results.map { $0.toRelease() }
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: totalCount,
                    resultsRemaining: totalCount - offset - releases.count,
                    items: releases)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotFetch("Cannot fetch releases"))
            }
        }
    }

    func fetchReleases(forArtist: Artist, offset: Int, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", forArtist.mbid as CVarArg)
                let totalCount = try! self.privateManagedObjectContext.count(for: fetchRequest)
                let artist = try self.privateManagedObjectContext.fetch(fetchRequest).first
                let managedReleases = Array(artist!.releases)
                let releases = managedReleases.map { $0.toRelease() }
                let result = StorageResult.init(
                    offset: 0,
                    resultsTotal: totalCount,
                    resultsRemaining: totalCount - offset - releases.count,
                    items: releases)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, StorageError.cannotFetch("Cannot find artist to fetch releases."))
            }
        }
    }

    func updateUserRelease(releaseToUpdate: Release, completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedRelease> = ManagedRelease.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", releaseToUpdate.mbid as CVarArg)
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                if let managedRelease = results.first {
                    do {
                        managedRelease.fromRelease(release: releaseToUpdate)
                        let release = managedRelease.toRelease()
                        try self.privateManagedObjectContext.save()
                        let result = StorageResult.init(
                            offset: 0,
                            resultsTotal: 1,
                            resultsRemaining: 0,
                            items: [release])
                        completionHandler(result, nil)
                    } catch {
                        completionHandler(
                            nil,
                            StorageError.cannotUpdate("Cannot update artist with mbid \(String(describing: releaseToUpdate.mbid))")
                        )
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    StorageError.cannotUpdate("Cannot fetch release with mbid \(String(describing: releaseToUpdate.mbid)) to update")
                )
            }
        }
    }

    func createUserArtistImports(importsToCreate: [ArtistImport], completionHandler: @escaping (StorageResult?, StorageError?) -> Void) {
        fatalError("User Artist Imports are not stored locally.")
    }

}
