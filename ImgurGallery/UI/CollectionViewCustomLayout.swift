//
//  CollectionViewCustomLayout.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import UIKit

extension CollectionViewCustomLayout {
    static var defaultWidth: CGFloat = 170.0
    static var defaultLineSpacing: CGFloat = 20.0
    static var defaultInterSpacing: CGFloat = 10.0
}

class CollectionViewCustomLayout: UICollectionViewFlowLayout {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    private func commonInit() {
        self.minimumLineSpacing = CollectionViewCustomLayout.defaultLineSpacing
        self.minimumInteritemSpacing = CollectionViewCustomLayout.defaultInterSpacing
        if let frameWidth = self.collectionView?.frame.size.width {
            let width = (frameWidth - self.minimumInteritemSpacing * 2) / 2
            self.itemSize = CGSize(width: width, height: width)
        } else {
            self.itemSize = CGSize(width: CollectionViewCustomLayout.defaultWidth, height: CollectionViewCustomLayout.defaultWidth)
        }
    }
    
}
