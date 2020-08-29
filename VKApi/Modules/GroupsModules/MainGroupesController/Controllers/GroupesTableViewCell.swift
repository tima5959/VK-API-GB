//
//  GroupesTableViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class GroupesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var groupNamedLabel: UILabel!
    @IBOutlet weak var groupTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(tapToImage))
        imageViewOutlet.addGestureRecognizer(gesture)
        imageViewOutlet.isUserInteractionEnabled = true
        
    }
    
    @objc func tapToImage() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.3,
                       options: [.autoreverse],
                       animations: { [unowned self] in
                        let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
                        self.imageViewOutlet.transform = scale
        }) { [unowned self] _ in
            self.imageViewOutlet.transform = .identity
        }
    }
    
}
