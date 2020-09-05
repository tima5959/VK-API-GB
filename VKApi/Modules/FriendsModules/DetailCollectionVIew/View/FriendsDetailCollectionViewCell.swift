//
//  FriendsDetailCollectionViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class FriendsDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendsPhotos: UIImageView! {
        didSet {
            // corner radius
            friendsPhotos.layer.cornerRadius = 10

            // border
            friendsPhotos.layer.borderWidth = 1.0
            friendsPhotos.layer.borderColor = UIColor.black.cgColor

            // shadow
            friendsPhotos.layer.shadowColor = UIColor.black.cgColor
            friendsPhotos.layer.shadowOffset = CGSize(width: 3, height: 3)
            friendsPhotos.layer.shadowOpacity = 0.7
            friendsPhotos.layer.shadowRadius = 4.0
        }
    }
    
    @IBOutlet weak var nameOutlet: UILabel!
    
}
