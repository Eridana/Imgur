//
//  ImageRequest.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

class ImageRequest {
    
    private static let url = Settings.sharedInstance.imageInfoUrl
    
    static func imageInfo(for id: String, completion: @escaping ((IMImage?) -> (Void))) {
    
        let compoundUrl = self.url + "/\(id)"
        ApiManager.sharedInstance.get(from: compoundUrl, params: nil) { (data) in
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
