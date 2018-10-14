//
//  Extensions.swift
//  Numu Tracker
//
//  Created by Bradley Root on 3/11/18.
//  Copyright © 2018 Numu Tracker. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension Array where Element: JSONCodable {
    init(from url: String) {
        if let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let json = try? JSON(data: data),
            let arr = json.array {
            self = arr.compactMap { Element(json: $0) }
        } else {
            self = []
        }
    }
}

extension Array where Element: JSONCodable {
    init(with json: JSON) {
        if let arr = json.array {
            self = arr.compactMap { Element(json: $0) }
        } else {
            self = []
        }
    }
}

extension ReleaseItem: JSONCodable { }
extension ArtistItem: JSONCodable { }

extension String {
    static let logged = "logged"
    static let newReleased = "newReleased"
    static let newAnnouncements = "newAnnouncements"
    static let moreReleases = "moreReleases"
    static let username = "username"
    static let password = "password"
    static let activityCount = "activityCount"
}

extension UserDefaults {
    var logged: Bool {
        get {
            return bool(forKey: .logged)
        }
        set {
            set(newValue, forKey: .logged)
        }
    }
    
    var activityCount: Int {
        get {
            return integer(forKey: .activityCount)
        }
        set {
            set(newValue, forKey: .activityCount)
        }
    }
    
    var newReleased: Bool {
        get {
            return bool(forKey: .newReleased)
        }
        set {
            set(newValue, forKey: .newReleased)
        }
    }
    
    var newAnnouncements: Bool {
        get {
            return bool(forKey: .newAnnouncements)
        }
        set {
            set(newValue, forKey: .newAnnouncements)
        }
    }
    
    var moreReleases: Bool {
        get {
            return bool(forKey: .moreReleases)
        }
        set {
            set(newValue, forKey: .moreReleases)
        }
    }
}

extension Notification.Name {
    static let LoggedIn = Notification.Name(rawValue: "com.numutracker.loggedIn")
    static let LoggedOut = Notification.Name(rawValue: "com.numutracker.loggedOut")
    static let UpdatedArtists = Notification.Name(rawValue: "com.numutracker.artistsImported")
    static let ClosedLogRegPrompt = Notification.Name(rawValue: "com.numutracker.closedLogRegPrompt")
    static let CancelledSpotifyLogin = Notification.Name(rawValue: "com.numutracker.cancelledSpotifyLogin")
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

extension UIColor {
    static let shadow = UIColor(red: 28/255, green: 202/255, blue: 241/255, alpha: 1)
    static let background = UIColor(red: 48/255, green: 156/255, blue: 172/255, alpha: 1)
}

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask(with: URL(string: link)!, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                data.map { self.image = UIImage(data: $0) }
            }
        }).resume()
    }
}
