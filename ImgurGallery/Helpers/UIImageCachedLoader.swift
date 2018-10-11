//
//  UIImageCachedLoader.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 08.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit
import SDWebImage

public class UIImageCachedLoader {
    
    public static let sharedInstance = UIImageCachedLoader()
    
    private let cache: NSCache<NSString, UIImage>?
    private let downloader: SDWebImageDownloader?
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
        self.downloader = SDWebImageDownloader()
    }
    
    public func loadImageFor(id: String, url: URL, _ completion: @escaping ((UIImage?) -> Void)) {
        DispatchQueue.global(qos: .background).async {
                if let cachedVersion = self.cache?.object(forKey: id as NSString) {
                // use the cached version
                completion(cachedVersion)
            } else {
                self.downloader?.downloadImage(with: url, options: .scaleDownLargeImages, progress: nil) { (image, data, error, success) in
                    print("downloaded url = \(url) for image id \(id)")
                    // store in the cache
                    if let image = image {
                        self.cache?.setObject(image, forKey: id as NSString)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    public func clearCache() {
        self.cache?.removeAllObjects()
    }
}
