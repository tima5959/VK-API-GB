//
//  NewsTableViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 31.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    private var groups: [Groups] = []
    
    private let numberOfRows = 1
    private let columns: CGFloat = 1.0
    private let inset: CGFloat = 8.0
    private let spacing: CGFloat = 8.0
    private let lineSpacing: CGFloat = 8.0
    
    var isLiked = false
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        }
    } // Аватар новости
    @IBOutlet weak var titleNewsFeed: UILabel!        // Название автора новости
    @IBOutlet weak var lastOnlineTime: UILabel!       // Последнее время онлайн
    
    @IBOutlet weak var newsTitleText: UILabel!        // Основной текст поста
    @IBOutlet weak var likeCountTitle: UILabel!       // Количество лайков
    @IBOutlet weak var shareCountTitle: UILabel!      // Количество репостов
    @IBOutlet weak var viewsCountTitle: UILabel!      // Количество просмотров
    
    @IBOutlet weak var heartLikeTitle: UIButton!      // Кнопка лайка
    
    // TODO: Заменить стеки на контролы
    @IBOutlet weak var likeTitleAction: UIStackView!  // Стек кнопки лайка и лейбла количества лайков
    @IBOutlet weak var shareTitleAction: UIStackView! // Стек кнопки репоста и лейбла количества репостов
    // TODO: Заменить ИмеджВью на КоллекшнВью
    @IBOutlet weak var animateImageView: UIImageView! // Имедж вью
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToImage))
        animateImageView.addGestureRecognizer(gesture)
        animateImageView.isUserInteractionEnabled = true
    }
    
    @IBAction func likeHeartAction(_ sender: UIButton) {
        isLiked.toggle()
        likeCountTitle.isUserInteractionEnabled = true
        if isLiked == true {
            UIView.animate(withDuration: 0.5) {
                self.heartLikeTitle.tintColor = .red
                self.heartLikeTitle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.heartLikeTitle.transform = CGAffineTransform(rotationAngle: .pi)
                self.heartLikeTitle.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.heartLikeTitle.tintColor = .blue
                self.heartLikeTitle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.heartLikeTitle.transform = CGAffineTransform(rotationAngle: .pi)
                self.heartLikeTitle.transform = .identity
            }
        }
    }
    
    @objc func tapToImage() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: [.autoreverse],
                       animations: { [unowned self] in
                        self.animateImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { [unowned self] _ in
            self.animateImageView.transform = .identity
        }
    }
    
    func configure(_ data: [NewsFeedModel], at indexPath: IndexPath) -> Void {
        let news = data[indexPath.row]
        
        avatarImageView.kf.setImage(with: URL(string: news.avatarURL ?? ""))
        
        animateImageView.kf.setImage(with: URL(string: news.attachments?.first?.photo?.sizes?.last?.url ?? ""))
        titleNewsFeed.text = news.name
        newsTitleText.text = news.text
        likeCountTitle.text = String("\(news.likes.count)")
        shareCountTitle.text = String("\(news.reposts.count)")
        viewsCountTitle.text = String("\(news.views.count)")
            
        lastOnlineTime.text = news.publicationTime(timeIntervalSince1970: news.date)
    }
}

//
//extension NewsTableViewCell: UICollectionViewDelegate,
//                             UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return numberOfRows
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCollectionViewCell
//
//        return cell
//    }
//
//
//}
//
//
//extension NewsTableViewCell: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////      let width = Int((collectionView.frame.width / columns) - (inset + spacing))
//        let width = Int(collectionView.frame.width / columns)
//
//      return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//      return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//      return spacing
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//      return lineSpacing
//    }
//}