//
//  GalleryModel.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import UIKit

class GalleryModel {
    
    public private(set) var id: String?
    public private(set) var title: String?
    public private(set) var descr: String?
    public private(set) var isAlbum: Bool = false
    public private(set) var imagesCount: Int = 0
    public private(set) var images: [ImageModel]?
    public private(set) var cover: ImageModel?    
    public private(set) var type: ContentType?
    public private(set) var url: URL?
    public private(set) var imageSize = CGSize(width: 0, height: 0)
    
    public var coverUrl: URL? {
        if self.isAlbum {
            return self.cover?.url ?? self.images?.first?.url ?? nil
        }
        return self.url
    }
    
    public var coverId: String? {
        if self.isAlbum {
            return self.cover?.id ?? self.images?.first?.id ?? nil
        }
        return self.id
    }
    
    internal var gallery: IMGallery?
    
    init(_ gallery: IMGallery) {
        self.gallery = gallery
        self.id = gallery.id
        self.title = gallery.title
        self.descr = gallery.galleryDescription
        self.isAlbum = gallery.isAlbum ?? false        
        if let link = gallery.link {
            self.url = URL(string: link)
        }
        self.type = gallery.contentType?.contentType()
        self.imagesCount = gallery.imagesCount ?? 0
        if let coverImage = gallery.coverImage {
            self.cover = ImageModel(coverImage)
        }
        self.images = gallery.images?.map({ (image) in ImageModel(image) })
        self.imageSize = CGSize(width: gallery.coverWidth ?? 0, height: gallery.coverHeight ?? 0)
    }    
}
