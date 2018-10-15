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

extension GalleryRequest {
    static var HotParamKey = "hot"
    static var ViralParamKey = "viral"
}

class GalleryRequest {
    
    private let urlPart = Settings.sharedInstance.galleryUrl
    private let imageRequest = ImageRequest()
    
    private var baseURL: URL? {
        return URL(string: self.urlPart)
    }
    
    func getGalleries(for page: Int, parameters: [String: Any], _ completion: @escaping (([IMGallery]?) -> Void)) {
        
        var combinedUrl = self.baseURL
        
        let useHot = parameters[GalleryRequest.HotParamKey] as? Bool ?? true
        
        if useHot {
            combinedUrl = combinedUrl?.appendingPathComponent("hot")
        } else {
            combinedUrl = combinedUrl?.appendingPathComponent("top")
        }
        
        let useViral = parameters[GalleryRequest.ViralParamKey] as? Bool ?? true
        
        let params: [String: Any]? = ["showViral" : useViral, "page" : page]
        
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
