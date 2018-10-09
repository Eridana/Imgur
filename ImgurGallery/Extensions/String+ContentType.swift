//
//  String+ContentType.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 08.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

extension String {
    func contentType() -> ContentType {
        if self.contains("gif") {
            return .gif
        } else if self.contains("mp4") {
            return .video
        } else if self.contains("jpeg") || self.contains("png") {
            return .image
        }
        return .unknown
    }
}
