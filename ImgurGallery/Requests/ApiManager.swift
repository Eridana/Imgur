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
    
    private var headers: [String: String] {
        get {
            return ["Authorization" : self.token]
        }
    }
    
    private init() {}
    
    public func get(from urlString: String, params: [String: Any]?, completion: @escaping ((Any?) -> Void)) {
        
        guard let url = URL(string: String(format: "%@%@", self.endpoint, urlString)) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: self.headers).responseJSON { (response) in
            print(response.request ?? "No request in response")
            print(response.result.debugDescription)
            completion(response.data)
        }
    }
}
