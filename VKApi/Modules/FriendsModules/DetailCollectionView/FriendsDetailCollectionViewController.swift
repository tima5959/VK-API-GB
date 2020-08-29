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
    
    var users: [Friend] = []
    var images: [UIImage] = []
    var ownerID: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.isPagingEnabled = true
        
        let session = URLSession(configuration: .default)
        
        let userID = Session.shared.userId
        var urlComponents = URLComponents()
        let scheme = "https"
        let version = "5.122"
        let vkApiHost = "api.vk.com"
        
        guard let owners = ownerID else { return }
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            .init(name: "user_ids", value: "\(userID)"),
            .init(name: "owner_id", value: String(owners)),
            .init(name: "extended", value: "1"),
            .init(name: "photo_sizes", value: "1"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version),
        ]
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
//            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//            print(json ?? "")
            if let data = data, let images = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images.append(images)
                }
            }
            
        }.resume()
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
        
//        cell.friendsPhotos.image = images[indexPath.row]
        
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
