//
//  GalleryModel.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class GalleryModel {
    
    public private(set) var title: String?
    public private(set) var descr: String?
    public private(set) var isAlbum: Bool = false
    public private(set) var imagesCount: Int = 0
    public private(set) var images: [ImageModel]?
    public private(set) var cover: ImageModel?
    
    internal var gallery: IMGallery?
    
    init(_ gallery: IMGallery) {
        self.gallery = gallery
        self.title = gallery.title
        self.descr = gallery.galleryDescription
        self.isAlbum = gallery.isAlbum ?? false
        self.imagesCount = gallery.imagesCount ?? 0
        if let coverImage = gallery.coverImage {
            self.cover = ImageModel(coverImage)
        }        
        self.images = gallery.images?.map({ (image) in ImageModel(image) })
    }    
}
