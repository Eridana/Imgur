//
//  UIImageView+LoadingIndocator.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 08.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func showLoadingIndicator(style: UIActivityIndicatorView.Style = .gray) {
        if self.viewWithTag(12) == nil {
            let indicator = UIActivityIndicatorView(style: style)
            indicator.center = self.center
            indicator.tag = 12
            indicator.startAnimating()
            self.addSubview(indicator)
        }
    }
    
    public func hideLoadingIndicator() {
        if let indicator = self.viewWithTag(12) {
            indicator.removeFromSuperview()
        }
    }
}
