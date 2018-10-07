//
//  IMGallery.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class IMGallery: Codable {
    var id: String?
    var title: String?
    var galleryDescription: String?
    var isAlbum: Bool?
    var imagesCount: Int?
    var images: [IMImage]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case galleryDescription = "description"
        case isAlbum = "is_album"
        case imagesCount = "images_count"
        case images
    }
}
