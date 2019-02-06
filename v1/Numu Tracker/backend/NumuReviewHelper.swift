//
//  NumuReviewHelper.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/13/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import StoreKit

struct NumuReviewHelper {

    static func incrementActivityCount() {
        defaults.activityCount += 1
    }

    static func incrementAndAskForReview() {
        defaults.activityCount += 1

        switch defaults.activityCount {
        case 20:
            NumuReviewHelper().requestReview()
        case _ where defaults.activityCount % 50 == 0:
            NumuReviewHelper().requestReview()
        default:
            print("Activity count is:", defaults.activityCount)
        }
    }

    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }

}
