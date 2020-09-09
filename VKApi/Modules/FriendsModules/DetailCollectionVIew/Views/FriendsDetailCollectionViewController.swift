//
//  FriendsDetailCollectionViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "friendsCollectionItem"

class FriendsDetailCollectionViewController: UICollectionViewController {
    
    let network = NetworkService()
    
    var users: [Friend] = []
    var images: [Photo] = []
    var ownerID: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.network.fetchAllPhoto(user: self.ownerID, { [weak self] photo in
                self?.images = photo
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }) { [unowned self] error in
                guard let error = error else { return }
                let alert = UIAlertController(title: "Photo not found",
                                              message: error,
                                              preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsDetailCollectionViewCell
        
        let image = images[indexPath.item]
        
        //        cell.friendsPhotos.image = network.setPhoto(atIndexPath: indexPath, byUrl: image.sizes.last?.url ?? "")
        cell.friendsPhotos.kf.setImage(with: URL(string: image.sizes.last?.url ?? ""), options: [])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0.5
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1) {
            cell.alpha = 0.5
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
}
