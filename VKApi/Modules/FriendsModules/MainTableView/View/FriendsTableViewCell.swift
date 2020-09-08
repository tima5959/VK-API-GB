//
//  FriendsTableViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // shadow
        avatarImageView.layer.shadowColor = UIColor.black.cgColor
        avatarImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        avatarImageView.layer.shadowOpacity = 0.7
        avatarImageView.layer.shadowRadius = 4.0
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapOnAvatar))
        avatarImageView.addGestureRecognizer(tap)
        avatarImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapOnAvatar() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: { [unowned self] in
                        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        self.avatarImageView.transform = scale
        }) { [unowned self] _ in
            self.avatarImageView.transform = .identity
        }
    }
    
//    public func configure(_ model: Friend) {
//        self.nameLabel.text = model.firstName
//    }
}
