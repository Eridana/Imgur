//
//  GalleryCVC.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryCVC: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    internal var model: GalleryModel?
    let downloader = SDWebImageDownloader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        //self.imageView.image = nil
        //self.titleLabel.text = nil
    }
    
    func setup(with model: GalleryModel?) {
        self.model = model
        self.titleLabel.text = model?.title ?? model?.descr
        if self.imageView.image != nil {
            return
        }
        if let url = model?.cover?.url {
            let type = model?.cover?.type ?? .unknown
            downloader.downloadImage(with: url, options: .scaleDownLargeImages, progress: { (i, x, url) in
            }) { (image, data, error, success) in
                print("TYPE: " + (self.model?.cover?.type.rawValue ?? "no type"))
                self.imageView.image = image
            }
        }
        /*
        if let url = model?.cover?.url {
            DispatchQueue.global(qos: .background).async {
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed) { (image, error, cacheType, url) in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
            
        }*/
    }

}
