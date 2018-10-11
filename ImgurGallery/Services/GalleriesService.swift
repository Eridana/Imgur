//
//  GalleriesService.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class GalleriesService {
    
    private var request = GalleryRequest()
    private let imageRequest = ImageRequest()
    
    public func loadGalleries(for page: Int, type: GalleryType, useViral: Bool, _ completion: @escaping ([GalleryModel]?) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            self.request.getGalleries(for: page, type: type, viral: useViral) { (result) in
                
                // request cover images info
                let dispatchGroup = DispatchGroup()
                for gallery in result ?? [] {
                    if let coverId = gallery.coverImageId {
                        dispatchGroup.enter()
                        self.imageRequest.imageInfo(for: coverId, completion: { (cover) -> (Void) in
                            gallery.coverImage = cover
                            dispatchGroup.leave()
                        })
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    let galleries = result?.map({ (gallery) in GalleryModel(gallery) })
                    completion(galleries)
                }                
            }
        }
    }
}
