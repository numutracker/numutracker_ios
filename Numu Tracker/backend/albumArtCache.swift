//
//  albumArtCache.swift
//  Numu Tracker
//
//  Created by Bradley Root on 10/6/16.
//  Copyright © 2016 Numu Tracker. All rights reserved.
//

import UIKit

class ImageCache : NSCache<NSString, UIImage> {
    init(name: String, limit: Int, totalCostLimit: Int) {
        super.init()
        self.name = name
        self.countLimit = limit
        self.totalCostLimit = totalCostLimit
    }

    static let shared = ImageCache(name: "ImageCache",
                                   limit: 200, // Max 200 images in memory.
                                   totalCostLimit: 50*1024*1024) // Max 50MB used.
}

extension NSURL {

    typealias ImageCacheCompletion = (UIImage) -> Void

    var cachedImage: UIImage? {
        return ImageCache.shared.object(forKey: self.absoluteString! as NSString) as UIImage?
    }

    func fetchImage(completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with: self as URL) { data, response, error in
            guard error == nil, let data = data, let image = UIImage(data: data) else { return }

            ImageCache.shared.setObject(image,
                                        forKey: self.absoluteString! as NSString,
                                        cost: data.count)
            DispatchQueue.main.async(execute: {
                completion(image)
            })
        }
        task.resume()
    }

}
