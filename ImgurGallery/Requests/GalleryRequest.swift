//
//  GalleryRequest.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

enum GalleryType {
    case hot
    case top
}

class GalleryRequest {
    
    private static let url = Settings.sharedInstance.galleryUrl
    
    static func getGalleries(with type: GalleryType, completion: @escaping (([IMGallery]?) -> Void)) {
        
        let params: [String: Any]? = ["showViral" : true]
        
        var combinedUrl = self.url
        
        switch type {
        case .hot:
            combinedUrl.append("/hot")
            break
        case .top:
            combinedUrl.append("/top")
            break
        }
        
        ApiManager.sharedInstance.get(from: combinedUrl, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(IMGalleryRequestResult.self, from: data)
                    // request cover images info
                    guard let galleries = decoded.galleries else {
                        completion(nil)
                        return
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    for gallery in galleries {
                        if let coverId = gallery.coverImageId {
                            dispatchGroup.enter()
                            ImageRequest.imageInfo(for: coverId, completion: { (cover) -> (Void) in
                                gallery.coverImage = cover
                                dispatchGroup.leave()
                            })
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(decoded.galleries)
                    }
                    
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
}
