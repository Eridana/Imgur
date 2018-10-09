//
//  GalleriesService.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class GalleriesService {
    
    public func galleries(_ completion: @escaping ([GalleryModel]?) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            GalleryRequest.getGalleries(with: .hot) { (result) in
                guard let result = result else {
                    print("No galleries")
                    completion(nil)
                    return
                }
                completion(result.map({ (gallery) in
                    GalleryModel(gallery)
                }))
            }
        }
    }    
}
