//
//  albumArtCache.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/6/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class MyImageCache {
    
    static let sharedCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "MyImageCache"
        cache.countLimit = 200 // Max 200 images in memory.
        cache.totalCostLimit = 50*1024*1024 // Max 50MB used.
        return cache
    }()
    
}

extension NSURL {
    
    typealias ImageCacheCompletion = (UIImage) -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        let TheString: NSString = NSString(string: self.absoluteString!)
        return MyImageCache.sharedCache.object(forKey: TheString) as UIImage?
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with: self as URL) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    let image = UIImage(data: data) {
                    let TheString: NSString = NSString(string: self.absoluteString!)
                    MyImageCache.sharedCache.setObject(
                        image,
                        forKey: TheString,
                        cost: data.count)
                   DispatchQueue.main.async(execute: {
                        completion(image)
                    })
                }
            }
        }
        task.resume()
    }
    
}
