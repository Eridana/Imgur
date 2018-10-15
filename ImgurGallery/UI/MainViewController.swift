//
//  MainViewController.swift
//  ImgurGallery
//
//  Created by Женя Михайлова on 07.10.2018.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    internal var model: GalleryViewModel?
    internal var showTable = false
    internal var staggeredLayout = StaggeredLayout()
    internal var gridLayout = CollectionViewCustomLayout()
    
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
        self.staggeredLayout.delegate = self
        self.gridLayout.update(for: self.collectionView.bounds)
        self.setLayout(as: self.gridLayout)
        self.collectionView.register(UINib(nibName: String(describing: GalleryCVC.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCVC.self))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.prefetchDataSource = self
        self.tableView.register(UINib(nibName: String(describing: GalleryTVC.self), bundle: nil), forCellReuseIdentifier: String(describing: GalleryTVC.self))
    }
    
    func setLayout(as layout: UICollectionViewLayout) {
        self.collectionView.collectionViewLayout = layout
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
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
        
        self.tableView.isHidden = !self.showTable
        self.collectionView.isHidden = self.showTable
        
        self.showIndicator()
        let hot = sender.selectedSegmentIndex == 0
        self.model?.switchType(to: hot)
        
        if self.showTable {
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        } else {
            self.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        }
    }
    
    @IBAction func showViralChanged(_ sender: UISwitch) {
        
        self.tableView.isHidden = !self.showTable
        self.collectionView.isHidden = self.showTable
        
        self.showIndicator()
        self.model?.changeViral(sender.isOn)
    }

    @IBAction func aboutTapped(_ sender: Any) {
        let aboutController = AboutViewController.instantiateFromNib()
        self.present(aboutController, animated: false, completion: nil)
    }
    
    @IBAction func changeLayout(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.setLayout(as: self.staggeredLayout)
        } else {
            self.setLayout(as: self.gridLayout)
        }
    }
    
    @IBAction func viewControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if self.showTable {
                self.showTable = false
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }            
        } else {
            if !self.showTable {
                self.showTable = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Table View

extension MainViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalleryTVC.self)) as? GalleryTVC else {
            return UITableViewCell()
        }
        if isLoadingCell(for: indexPath) {
            cell.setup(with: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            (cell as? GalleryTVC)?.setup(with: self.model?.gallery(at: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.model?.fetchGalleries()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
}

// MARK: - Collection View

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
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
            (cell as? GalleryCVC)?.setup(with: self.model?.gallery(at: indexPath))
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
            self.tableView.isHidden = !self.showTable
            self.collectionView.isHidden = self.showTable
            
            if self.showTable {
                self.tableView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        
        if self.showTable {
            self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
        else {
            self.collectionView.reloadItems(at: indexPathsToReload)
        }
    }
}

private extension MainViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let result = indexPath.row >= (self.model?.currentCount ?? 0)
        return result
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = self.showTable ? self.tableView.indexPathsForVisibleRows ?? [] : self.collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MainViewController: StaggeredLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        if let gallery = self.model?.gallery(at: indexPath) {
            let size = gallery.imageSize
            print(size.height)
            return size.height
        }
        return 200
    }
}

