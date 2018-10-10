//
//  ImageRequest.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class ImageRequest {
    
    private let urlPart = Settings.sharedInstance.imageInfoUrl
    
    private var baseURL: URL? {
        return URL(string: self.urlPart)
    }
    
    func imageInfo(for id: String, completion: @escaping ((IMImage?) -> (Void))) {
    
        guard let combinedUrl = self.baseURL?.appendingPathComponent(id) else {
            completion(nil)
            return
        }
        
        ApiManager.sharedInstance.get(from: combinedUrl, params: nil) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(IMImageRequestResult.self, from: data)
                    completion(decoded.image)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
}
