//
//  ImageModel.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

enum ContentType: String {
    case image
    case gif
    case video
    case unknown
}

class ImageModel {
    
    public private(set) var id: String?
    public private(set) var title: String?
    public private(set) var descr: String?
    public private(set) var url: URL?
    public private(set) var animated: Bool = false
    public private(set) var type: ContentType?
    
    internal var image: IMImage?
    
    init(_ image: IMImage) {
        self.image = image
        self.id = image.id
        self.title = image.title
        self.descr = image.imageDescription
        self.animated = image.animated ?? false
        if let link = image.link {
            self.url = URL(string: link)
        }
        self.type = image.contentType?.contentType()
    }
}
