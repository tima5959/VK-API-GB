//
//  CellCollectionViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 04.10.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class CellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        }
    }  // Аватар автора новости
    
    @IBOutlet weak var heartControl: HeartControl!
    @IBOutlet weak var commentsControl: CommentsControl!
    
    @IBOutlet weak var titleNewsFeed: UILabel!        // Название автора новости
    @IBOutlet weak var publicationTime: UILabel!       // Последнее время онлайн
    @IBOutlet weak var newsTitleText: UILabel!        // Основной текст поста
    @IBOutlet weak var galleryImageView: UIImageView! // Фото новости
                                                      // Констрейнт высоты фото новости
    @IBOutlet weak var galleryImageViewHeightConstraint: NSLayoutConstraint!
    
    func configureCell(byData: NewsFeedModel,
                       networkService: NetworkService?,
                       imageHeight: CGFloat?) -> Void {
        
        if let network = networkService {
            network.fetchAndCachedPhoto(
                from: byData.avatarURL ?? "",
                completionHandler: { image in
                    self.avatarImageView.image = image
                }, completionError: { error in
                    self.avatarImageView.image = UIImage(named: "")
                })
            
            network.fetchAndCachedPhoto(
                from: (byData.attachments?.first?.photo?.sizes?.last?.url) ?? ""
            ) { image in
                self.galleryImageView.image = image
            } completionError: { error in
                self.galleryImageView.image = UIImage(named: "")
            }
            
        }
        
        titleNewsFeed.text = byData.name
        newsTitleText.text = byData.text
        
        publicationTime.text = byData.publicationTime(timeIntervalSince1970: byData.date)
        
        galleryImageViewHeightConstraint.constant = imageHeight ?? 0
        
        heartControl.set(byData.likes.count)
        commentsControl.set(byData.comments.count)
    }
    
}
