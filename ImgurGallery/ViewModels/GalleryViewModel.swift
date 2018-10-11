//
//  GalleryViewModel.swift
//  ImgurGallery
//
//  Created by Evgeniia Mikhailova on 10.10.18.
//  Copyright © 2018 Evgeniya Mikhailova. All rights reserved.
//

import Foundation

protocol GalleryViewModelDelegate {
    func fetchDidFail(with error: String?)
    func fetchDidComplete(with newIndexPathsToReload: [IndexPath]?)
}

class GalleryViewModel {
    
    public var delegate: GalleryViewModelDelegate?
    
    public var currentCount: Int {
        return self.galleries.count
    }
    
    public var totalCount: Int {
        return self.total
    }
    
    private var galleries = [GalleryModel]()
    private var galleryType: GalleryType = .hot
    private var useViral = true
    private var currentPage: Int = 0
    // limit max count with this value, because api doesn't return total galleries amount :(
    private var total: Int = 2000
    private var service = GalleriesService()
    private var isFetchInProgress = false
    
    init(delegate: GalleryViewModelDelegate?) {
        self.delegate = delegate
    }
    
    public func switchType(to hot: Bool) {
        self.galleryType = hot ? .hot : .top
        self.reload()
    }
    
    public func changeViral(_ useViral: Bool) {
        self.useViral = useViral
        self.reload()
    }
    
    public func gallery(at index: Int) -> GalleryModel? {
        return self.galleries[index]
    }
    
    public func fetchGalleries() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        self.service.loadGalleries(for: self.currentPage, type: self.galleryType, useViral: self.useViral, { (result) -> (Void) in
            if let result = result {
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    
                    // hide video galleries for now
                    let resultFiltered = result.filter({ (model) -> Bool in
                        (model.cover?.type ?? .unknown) != .video
                    })
                    
                    self.galleries.append(contentsOf: resultFiltered)
                    
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: result)
                        self.delegate?.fetchDidComplete(with: indexPathsToReload)
                    } else {
                        self.delegate?.fetchDidComplete(with: .none)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.fetchDidFail(with: "No galleries fetched")
                    return
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newGalleries: [GalleryModel]) -> [IndexPath] {
        let startIndex = galleries.count - newGalleries.count
        let endIndex = startIndex + newGalleries.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func reload() {
        self.galleries.removeAll()
        self.currentPage = 0
        self.fetchGalleries()
    }
}
