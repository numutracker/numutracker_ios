//
//  Extensions.swift
//  Numu Tracker
//
//  Created by Bradley Root on 2/9/19.
//  Copyright © 2019 Brad Root. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let shadow = UIColor(red: 28/255, green: 202/255, blue: 241/255, alpha: 1)
    static let background = UIColor(red: 48/255, green: 156/255, blue: 172/255, alpha: 1)
    static let lightBackground = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
}

extension String {
    static let logged = "logged"
    static let newReleased = "newReleased"
    static let newAnnouncements = "newAnnouncements"
    static let moreReleases = "moreReleases"
    static let activityCount = "activityCount"
    static let disabledAppleMusic = "disabledAppleMusic"
    static let enabledSpotify = "enabledSpotify"
    static let enabledYouTube = "enabledYouTube"
    static let enabledSoundCloud = "enabledSoundCloud"
    static let artistSortMethod = "artistSortMethod"
}

extension UserDefaults {
    var logged: Bool {
        get { return bool(forKey: .logged) }
        set { set(newValue, forKey: .logged) }
    }

    var activityCount: Int {
        get { return integer(forKey: .activityCount) }
        set { set(newValue, forKey: .activityCount) }
    }

    var disabledAppleMusic: Bool {
        get { return bool(forKey: .disabledAppleMusic) }
        set { set(newValue, forKey: .disabledAppleMusic) }
    }

    var enabledSpotify: Bool {
        get { return bool(forKey: .enabledSpotify) }
        set { set(newValue, forKey: .enabledSpotify) }
    }

    var enabledYouTube: Bool {
        get { return bool(forKey: .enabledYouTube) }
        set { set(newValue, forKey: .enabledYouTube) }
    }

    var enabledSoundCloud: Bool {
        get { return bool(forKey: .enabledSoundCloud) }
        set { set(newValue, forKey: .enabledSoundCloud) }
    }

    var artistSortMethod: String {
        get { return string(forKey: .artistSortMethod) ?? "name" }
        set { set(newValue, forKey: .artistSortMethod) }
    }
}
