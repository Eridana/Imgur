//
//  MainViewController.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let service = GalleriesService()
    internal var galleries: [GalleryModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.service.galleries { (result) -> (Void) in
            self.galleries = result?.filter({ (model) -> Bool in
                (model.cover?.type ?? .unknown) != .video
            })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = CollectionViewCustomLayout()
        self.collectionView.register(UINib(nibName: String(describing: GalleryCVC.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCVC.self))
    }

    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCVC.self), for: indexPath) as? GalleryCVC else {
            return UICollectionViewCell()
        }
        let gallery = self.galleries?[indexPath.row]
        //cell.setup(with: gallery)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let gallery = self.galleries?[indexPath.row] {
            print("row \(indexPath.row) gallery cover: \(gallery.cover?.image?.id ?? "nil")")
            (cell as? GalleryCVC)?.setup(with: gallery)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleries?.count ?? 0
    }
    
    /*
    
     public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let handler = self.handlers[indexPath.row]
         let height = self.heightFor(handler: handler)
         let width = self.widthFor(handler: handler)
         return CGSize(width: width, height: height);
     }
     
     public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 58.0
     }
     
     public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         var sliderWidth:CGFloat = 599.0
         let width = self.screenBounds.width
         if UIDevice.current.userInterfaceIdiom == .phone {
            return UIEdgeInsetsMake(0, 20, 0, 20)
         } else {
            if UIDevice.current.orientation.isPortrait {
                sliderWidth = 499
                return UIEdgeInsetsMake(0, (width - sliderWidth) / 2, 0, (width - sliderWidth) / 2)
            }
         }
         return UIEdgeInsetsMake(0, (width - sliderWidth) / 2, 0, (width - sliderWidth) / 2)
     }
     
     */
    
    
}
