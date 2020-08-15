//
//  FriendsDetailCollectionViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "friendsCollectionItem"

class FriendsDetailCollectionViewController: UICollectionViewController {
    
    var users: [String] = ["", "", "", "", ""]
    var ownerID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.shared.getPhotos(Session.shared.userId)
        
//        collectionView.isPagingEnabled = true
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendsDetailCollectionViewCell
        
        //        let user = users[indexPath.row]
        //        cell.nameOutlet.text = user
        
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
