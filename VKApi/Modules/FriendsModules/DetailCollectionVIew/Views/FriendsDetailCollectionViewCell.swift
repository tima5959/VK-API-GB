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
            // shadow
            friendsPhotos.layer.shadowColor = UIColor.black.cgColor
            friendsPhotos.layer.shadowOffset = CGSize.zero
            friendsPhotos.layer.shadowOpacity = 0.8
            friendsPhotos.layer.shadowRadius = 8
        }
    }
    
    @IBOutlet weak var nameOutlet: UILabel!
    
}
