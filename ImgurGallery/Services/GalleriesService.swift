//
//  GalleriesService.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class GalleriesService {
    
    internal var page: Int = 0
    internal var galleries: [GalleryModel]?
    internal var galleryType: GalleryType = .hot
    
    private var request = GalleryRequest()
    
    init() {
        self.galleries = [GalleryModel]()
    }
    
    public func fetchGalleries(_ completion: @escaping ([GalleryModel]?) -> (Void)) {
        self.loadGalleries(for: self.page, type: self.galleryType, { (result) -> (Void) in
            guard let result = result else {
                print("No galleries")
                completion(nil)
                return
            }
            self.page = self.page + 1
            self.galleries?.append(contentsOf: result)
            completion(self.galleries)
        })
    }
    
    private func loadGalleries(for page: Int, type: GalleryType, _ completion: @escaping ([GalleryModel]?) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            self.request.getGalleries(for: self.page, type: self.galleryType) { (result) in
                completion(result?.map({ (gallery) in GalleryModel(gallery) }))
            }
        }
    }
    
    public func switchType(to hot: Bool) {
        self.galleries?.removeAll()
        self.galleryType = hot ? .hot : .top
        self.page = 0
    }
    
    public func useViral(_ use: Bool) {
    
    }
}
