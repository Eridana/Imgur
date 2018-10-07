//
//  CollectionViewCustomLayout.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation
import UIKit

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
        self.itemSize = CGSize(width: 150.0, height: 150.0)
        self.minimumLineSpacing = 20.0
        self.minimumInteritemSpacing = 20.0
    }
    
}
