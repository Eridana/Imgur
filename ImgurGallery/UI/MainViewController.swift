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
        self.showIndicator()
        self.model?.fetchGalleries()
    }
    
    private func setup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        let layout = CollectionViewCustomLayout()
        layout.update(for: self.collectionView.bounds)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UINib(nibName: String(describing: GalleryCVC.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCVC.self))
    }
    
    func showIndicator() {
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
    }
    
    func hideIndicator() {
        self.indicatorView.isHidden = true
        self.indicatorView.stopAnimating()
    }
    
    // MARK: - Events
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.collectionView.isHidden = true
        self.showIndicator()
        let hot = sender.selectedSegmentIndex == 0
        self.model?.switchType(to: hot)
        self.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
    @IBAction func showViralChanged(_ sender: UISwitch) {
        self.collectionView.isHidden = true
        self.showIndicator()
        self.model?.changeViral(sender.isOn)
    }

    @IBAction func aboutTapped(_ sender: Any) {
        let aboutController = AboutViewController.instantiateFromNib()
        self.present(aboutController, animated: false, completion: nil)
    }
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCVC.self), for: indexPath) as? GalleryCVC else {
            return UICollectionViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.setup(with: .none)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            (cell as? GalleryCVC)?.setup(with: self.model?.gallery(at: indexPath.row))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.totalCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.model?.fetchGalleries()
        }
    }    
}

extension MainViewController: GalleryViewModelDelegate {
    
    func fetchDidFail(with error: String?) {
        self.hideIndicator()
        print("Fetch did fail with error: \(error ?? "")")
    }
    
    func fetchDidComplete(with newIndexPathsToReload: [IndexPath]?) {
        self.hideIndicator()
        
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
        return result
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = self.collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
