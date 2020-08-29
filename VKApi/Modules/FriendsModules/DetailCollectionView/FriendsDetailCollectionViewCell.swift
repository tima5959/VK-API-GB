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
            setShadowForImageView(friendsPhotos)
        }
    }
    
    @IBOutlet weak var nameOutlet: UILabel!
    
}
