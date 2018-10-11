//
//  GalleryRequest.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

enum GalleryType {
    case hot
    case top
}

class GalleryRequest {
    
    private let urlPart = Settings.sharedInstance.galleryUrl
    private let imageRequest = ImageRequest()
    
    private var baseURL: URL? {
        return URL(string: self.urlPart)
    }
    
    func getGalleries(for page: Int, type: GalleryType, viral: Bool, _ completion: @escaping (([IMGallery]?) -> Void)) {
        
        let params: [String: Any]? = ["showViral" : viral, "page" : page]
        
        var combinedUrl = self.baseURL
        
        switch type {
        case .hot:
            combinedUrl = combinedUrl?.appendingPathComponent("hot")
            break
        case .top:
            combinedUrl = combinedUrl?.appendingPathComponent("top")
            break
        }
        
        guard let resultURL = combinedUrl else {
            completion(nil)
            return
        }
        
        ApiManager.sharedInstance.get(from: resultURL, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(IMGalleryRequestResult.self, from: data)
                    completion(decoded.galleries)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
}
