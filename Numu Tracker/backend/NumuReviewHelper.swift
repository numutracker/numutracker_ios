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
        guard var activityCount = defaults.activityCount as? Int else {
            defaults.activityCount = 1
            return
        }
        activityCount += 1
        defaults.activityCount = activityCount
    }
    
    static func incrementAndAskForReview() {
        guard var activityCount = defaults.activityCount as? Int else {
            defaults.activityCount = 1
            return
        }
        activityCount += 1
        defaults.activityCount = activityCount
        
        switch activityCount {
        case 20:
            NumuReviewHelper().requestReview()
        case _ where activityCount % 50 == 0:
            NumuReviewHelper().requestReview()
        default:
            print("Activity count is:",activityCount)
        }
    }
    
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
}
