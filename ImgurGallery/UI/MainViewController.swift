//
//  MainViewController.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    internal var model: GalleryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = GalleryViewModel(delegate: self)
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func fetchData() {
        self.indicatorView.startAnimating()
        self.model?.fetchGalleries()
    }
    
    private func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        self.collectionView.collectionViewLayout = CollectionViewCustomLayout()
        self.collectionView.register(UINib(nibName: String(describing: GalleryCVC.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCVC.self))
    }
    
    // MARK: - Controls
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let hot = sender.selectedSegmentIndex == 0
        self.model?.switchType(to: hot)
    }
    

    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCVC.self), for: indexPath) as? GalleryCVC else {
            return UICollectionViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.setup(with: .none)
        } else {
            cell.setup(with: self.model?.gallery(at: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total count in controller = \(self.model?.totalCount ?? 0)")
        return self.model?.totalCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.model?.fetchGalleries()
        }
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

extension MainViewController: GalleryViewModelDelegate {
    
    func fetchDidFail(with error: String?) {
        self.indicatorView.stopAnimating()
        print("Fetch did fail with error: \(error ?? "")")
    }
    
    func fetchDidComplete(with newIndexPathsToReload: [IndexPath]?) {
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            self.indicatorView.stopAnimating()
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        self.collectionView.reloadItems(at: indexPathsToReload)
    }
}

private extension MainViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let result = indexPath.row >= (self.model?.currentCount ?? 0)
        print("isLoadingCell: \(result)")
        return result
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = self.collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
