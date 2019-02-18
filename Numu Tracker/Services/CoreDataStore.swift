//
//  CoreDataStore.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/17/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore: NumuStorageProtocol {

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

    // MARK: - Artists

    func createArtist(artistToCreate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
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
                completionHandler(artist, nil)
            } catch {
                print(error)
                completionHandler(nil, NumuStoreError.cannotCreate("Cannot create artist with mbid \(String(describing: artistToCreate.mbid))"))
            }
        }
    }

    func createArtists(artistsToCreate: [Artist], completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                var artists: [Artist] = []
                for artistToCreate in artistsToCreate {
                    let managedArtist = ManagedArtist(context: self.privateManagedObjectContext)
                    artists.append(artistToCreate)
                    managedArtist.fromArtist(artist: artistToCreate)
                }
                try self.privateManagedObjectContext.save()
                completionHandler(artists, nil)
            } catch {
                completionHandler([], NumuStoreError.cannotCreate("Could not create artist batch"))
            }
        }
    }

    func fetchArtists(sinceDateUpdated date: Date?, completionHandler: @escaping ([Artist], NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "following == %@", NSNumber(value: true))
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let artists = results.map { $0.toArtist() }
                completionHandler(artists, nil)
            } catch {
                completionHandler([], NumuStoreError.cannotFetch("Cannot fetch artists"))
            }
        }
    }

    func updateArtist(artistToUpdate: Artist, completionHandler: @escaping (Artist?, NumuStoreError?) -> Void) {
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
                        completionHandler(artist, nil)
                    } catch {
                        completionHandler(
                            nil,
                            NumuStoreError.cannotUpdate("Cannot update artist with mbid \(String(describing: artistToUpdate.mbid))")
                        )
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    NumuStoreError.cannotUpdate("Cannot fetch artist with mbid \(String(describing: artistToUpdate.mbid)) to update")
                )
            }
        }
    }

    // MARK: - Releases

    func createRelease(releaseToCreate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
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
                completionHandler(release, nil)
            } catch {
                completionHandler(nil, NumuStoreError.cannotCreate("Cannot create release with mbid \(String(describing: releaseToCreate.mbid))"))
            }
        }
    }

    func createReleases(releasesToCreate: [Release], completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                var releases: [Release] = []
                for releaseToCreate in releasesToCreate {
                    let managedRelease = ManagedRelease(context: self.privateManagedObjectContext)
                    releases.append(releaseToCreate)
                    managedRelease.fromRelease(release: releaseToCreate)
                }
                try self.privateManagedObjectContext.save()
                completionHandler(releases, nil)
            } catch {
                completionHandler([], NumuStoreError.cannotCreate("Could not create release batch"))
            }
        }
    }

    func fetchReleases(sinceDateUpdated date: Date?, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedRelease> = ManagedRelease.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "following == %@", NSNumber(value: true))
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                let releases = results.map { $0.toRelease() }
                completionHandler(releases, nil)
            } catch {
                completionHandler([], NumuStoreError.cannotFetch("Cannot fetch releases"))
            }
        }
    }

    func fetchReleases(forArtist: Artist, completionHandler: @escaping ([Release], NumuStoreError?) -> Void) {
        completionHandler([], nil)
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedArtist> = ManagedArtist.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "mbid == %@", forArtist.mbid as CVarArg)
                let artist = try self.privateManagedObjectContext.fetch(fetchRequest).first
                let managedReleases = Array(artist!.releases)
                let releases = managedReleases.map { $0.toRelease() }
                completionHandler(releases, nil)
            } catch {
                completionHandler([], NumuStoreError.cannotFetch("Cannot find artist to fetch releases."))
            }
        }
    }

    func updateRelease(releaseToUpdate: Release, completionHandler: @escaping (Release?, NumuStoreError?) -> Void) {
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
                        completionHandler(release, nil)
                    } catch {
                        completionHandler(
                            nil,
                            NumuStoreError.cannotUpdate("Cannot update artist with mbid \(String(describing: releaseToUpdate.mbid))")
                        )
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    NumuStoreError.cannotUpdate("Cannot fetch release with mbid \(String(describing: releaseToUpdate.mbid)) to update")
                )
            }
        }
    }

    // MARK: - User

    func createUser(userToCreate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let managedUser = ManagedUser(context: self.privateManagedObjectContext)
                let user = userToCreate
                managedUser.fromUser(user: userToCreate)
                try self.privateManagedObjectContext.save()
                completionHandler(user, nil)
            } catch {
                completionHandler(nil, NumuStoreError.cannotCreate("Cannot create user with id \(String(describing: userToCreate.userId))"))
            }
        }
    }

    func fetchUser(completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
                let managedUser = try self.privateManagedObjectContext.fetch(fetchRequest).first
                let user = managedUser!.toUser()
                completionHandler(user, nil)
            } catch {
                completionHandler(nil, NumuStoreError.cannotFetch("No user found"))
            }
        }
    }

    func updateUser(userToUpdate: User, completionHandler: @escaping (User?, NumuStoreError?) -> Void) {
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
                        completionHandler(user, nil)
                    } catch {
                        completionHandler(nil, NumuStoreError.cannotUpdate("Cannot update user with id \(String(describing: userToUpdate.userId))"))
                    }
                }
            } catch {
                completionHandler(
                    nil,
                    NumuStoreError.cannotUpdate("Cannot fetch release with mbid \(String(describing: userToUpdate.userId)) to update")
                )
            }
        }
    }

}
