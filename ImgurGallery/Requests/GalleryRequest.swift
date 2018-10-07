//
//  GalleryRequest.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

enum GalleryType {
    case hot
    case top
}

class GalleryRequest {
    
    private static let url = Settings.sharedInstance.galleryUrl
    
    static func getGallery(with type: GalleryType, completion: @escaping ((IMGalleryRequestResult?) -> Void)) {
        
        let params: [String: Any]? = ["showViral" : true]
        
        var combinedUrl = self.url
        
        switch type {
        case .hot:
            combinedUrl.append("/hot")
            break
        case .top:
            combinedUrl.append("/top")
            break
        }
        
        ApiManager.sharedInstance.get(from: combinedUrl, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(IMGalleryRequestResult.self, from: data)
                    completion(decoded)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
}
