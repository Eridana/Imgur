//
//  IMImage.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class IMImage: Codable {
    var id: String?
    var title: String?
    var imageDescription: String?
    var animated: Bool?
    var link: String?
    var contentType: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageDescription = "description"
        case animated
        case link
        case contentType = "type"
    }
}
