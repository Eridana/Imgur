//
//  GalleryTVC.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 15.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class GalleryTVC: UITableViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    internal var model: GalleryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicator.startAnimating()
    }
    
    override func prepareForReuse() {
        self.galleryImageView.image = nil
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
                    self.galleryImageView.image = image
                }
            }
        }
    }
}
