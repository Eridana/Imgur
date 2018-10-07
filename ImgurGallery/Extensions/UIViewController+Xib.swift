//
//  UIViewController+Xib.swift
//  ImgurGallery
//
//  Created by Evgeniya Mikhailova on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiateFromNib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
}
