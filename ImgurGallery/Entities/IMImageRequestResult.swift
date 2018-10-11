//
//  IMImageRequestResult.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class IMImageRequestResult: Codable {
    var image: IMImage?
    
    private enum CodingKeys: String, CodingKey {
        case image = "data"
    }
}
