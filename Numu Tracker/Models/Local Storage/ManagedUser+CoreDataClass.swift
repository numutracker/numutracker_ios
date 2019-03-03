//
//  ManagedUser+CoreDataClass.swift
//  
//
//  Created by Bradley Root on 2/17/19.
//
//

import Foundation
import CoreData

@objc(ManagedUser)
public class ManagedUser: NSManagedObject {

    func toUser() -> User {
        return User.init(
            userId: Int(id),
            albumFilter: albumFilter,
            epFilter: epFilter,
            singleFilter: singleFilter,
            liveFilter: liveFilter,
            soundtrackFilter: soundtrackFilter,
            remixFilter: remixFilter,
            otherFilter: otherFilter,
            dateLastActivity: dateLastActivity! as Date)
    }

    func fromUser(user: User) {
        id = Int64(user.userId)
        albumFilter = user.albumFilter
        epFilter = user.epFilter
        singleFilter = user.singleFilter
        liveFilter = user.liveFilter
        soundtrackFilter = user.soundtrackFilter
        remixFilter = user.remixFilter
        dateLastActivity = user.dateLastActivity as NSDate?
    }

}
