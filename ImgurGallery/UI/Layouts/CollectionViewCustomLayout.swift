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
    static var defaultSectionInset: CGFloat = 20.0
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
        self.itemSize = CGSize(width: CollectionViewCustomLayout.defaultWidth, height: CollectionViewCustomLayout.defaultWidth)
        self.sectionInset = UIEdgeInsets(top: 0, left: CollectionViewCustomLayout.defaultSectionInset, bottom: 0, right: CollectionViewCustomLayout.defaultSectionInset)
    }
    
    public func update(for frame: CGRect, numberOfElementsInLine: Int = 2) {
        let width = (frame.width - CollectionViewCustomLayout.defaultSectionInset * 2 - self.minimumInteritemSpacing * CGFloat(numberOfElementsInLine - 1)) / CGFloat(numberOfElementsInLine)
        self.itemSize = CGSize(width: width, height: width)
    }
}
