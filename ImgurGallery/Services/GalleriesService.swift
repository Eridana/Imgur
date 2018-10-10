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
    
    public func loadGalleries(for page: Int, type: GalleryType, useViral: Bool, _ completion: @escaping ([GalleryModel]?) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            self.request.getGalleries(for: page, type: type, viral: useViral) { (result) in
                let galleries = result?.map({ (gallery) in GalleryModel(gallery) })
                completion(galleries)
            }
        }
    }
}
