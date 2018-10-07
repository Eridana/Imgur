//
//  Settings.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

extension Settings {
    internal static var settingsPlistName = "network_settings"
    internal static var baseUrlKey = "base_url"
    internal static var galleryUrlKey = "gallery_url"
    internal static var imageUrlKey = "image_info_url"
    internal static var tokenKey = "token"
}

class Settings {
    public static let sharedInstance = Settings()
    private var settingsDictionary: [String : String]?
    
    private init() {
        self.settingsDictionary = self.readDictionary(from: Settings.settingsPlistName)
    }
    
    public var baseUrl: String {
        return self.property(for: Settings.baseUrlKey)
    }
    
    public var galleryUrl: String {
        return self.property(for: Settings.galleryUrlKey)
    }
    
    public var imageInfoUrl: String {
        return self.property(for: Settings.imageUrlKey)
    }
    
    public var token: String {
        return self.property(for: Settings.tokenKey)
    }
    
    private func property(for name: String) -> String {
        guard let value = self.settingsDictionary?[name] else {
            print("Warning: property \(name) not found")
            return ""
        }
        return value
    }
    
    private func readDictionary(from plistName: String) -> Dictionary<String, String>? {
        guard let dict = self.readPlist(plistName) else {
            print("Warning: File \(plistName).plist not found")
            return nil
        }
        return dict as? Dictionary<String, String>
    }
    
    private func readPlist(_ name: String) -> NSDictionary? {
//        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }
}
