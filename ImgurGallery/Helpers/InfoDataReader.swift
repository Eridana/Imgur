//
//  InfoDataReader.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 11.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

extension InfoDataReader {
    internal static var EmailKey = "author_email"
    internal static var VersionKey = "CFBundleShortVersionString"
    internal static var BuildNumberKey = "CFBundleVersion"
}

class InfoDataReader {
    
    private var plist: Dictionary<String, Any?>?
    
    init() {
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist") {
            self.plist = NSDictionary(contentsOfFile: infoPath) as? Dictionary<String, Any?>
        }
    }

    public var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: InfoDataReader.VersionKey) as? String
    }
    
    public var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: InfoDataReader.BuildNumberKey) as? String
    }
    
    public var  buildDate: Date? {
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"), let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath) {
            return infoAttr[FileAttributeKey.creationDate] as? Date
        }
        return nil
    }
    
    public var email:  String? {
        return self.plist?[InfoDataReader.EmailKey] as? String
    }
    
}
