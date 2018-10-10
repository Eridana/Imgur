//
//  ApiManager.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 06.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager {
    
    public static let sharedInstance = ApiManager()
    
    private let endpoint = Settings.sharedInstance.baseUrl
    private let token = Settings.sharedInstance.token
    
    private var baseURL: URL? {
        return URL(string: self.endpoint)
    }
    
    private var headers: [String: String] {
        get {
            return ["Authorization" : self.token]
        }
    }
    
    private init() {}
    
    public func get(from endUrl: URL, params: [String: Any]?, completion: @escaping ((Any?) -> Void)) {
        
        guard let url = self.baseURL?.appendingPathComponent(endUrl.path) else {
            completion(nil)
            return
        }
        
        print(url.absoluteString)
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: self.headers).responseJSON { (response) in
            print(response.request ?? "No request in response")
            print(response.result.debugDescription)
            completion(response.data)
        }
    }
}
