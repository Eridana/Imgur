//
//  GalleryCVC.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class GalleryCVC: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    internal var model: GalleryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.model = nil
        self.titleLabel.text = nil
    }
    
    func setup(with model: GalleryModel?) {
        self.model = model
        self.titleLabel.text = model?.title ?? model?.descr
        if let url = model?.coverUrl, let id = self.model?.coverId {
            UIImageCachedLoader.sharedInstance.loadImageFor(id: id, url: url) { (image) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                    self.imageView.image = image
                }
            }
        }
    }
}
