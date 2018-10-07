//
//  IMGalleryRequestResult.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class IMGalleryRequestResult: Codable {
    var galleries: [IMGallery]?
    
    private enum CodingKeys: String, CodingKey {
        case galleries = "data"
    }
}
