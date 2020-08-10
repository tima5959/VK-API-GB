//
//  NewsTableViewCell.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 31.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    let numberOfRows = 1
    let columns: CGFloat = 1.0
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    let lineSpacing: CGFloat = 8.0
    
    var imageArray = [String] ()
    
    var isLiked = false
    
    @IBOutlet weak var newsTitleText: UILabel!
    @IBOutlet weak var likeCountTitle: UILabel! {
        didSet {
            if isLiked == true {
                likeCountTitle.text = "1"
            } else {
                likeCountTitle.text = "0"
            }
        }
    }
    
    @IBOutlet weak var shareCountTitle: UILabel!
    @IBOutlet weak var viewsCountTitle: UILabel!
    
    
    @IBOutlet weak var heartLikeTitle: UIButton!
    
    @IBOutlet weak var likeTitleAction: UIStackView!
    
    @IBOutlet weak var shareTitleAction: UIStackView!
    @IBOutlet weak var animateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageArray = [
            "photollllll",
            "photollllll",
            "photollllll",
            "photollllll",
            "photollllll",
            "photollllll"
        ]
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToImage))
        animateImageView.addGestureRecognizer(gesture)
        animateImageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func likeHeartAction(_ sender: UIButton) {
        isLiked.toggle()
        likeCountTitle.isUserInteractionEnabled = true
        if isLiked == true {
            likeCountTitle.text = "1"
            UIView.animate(withDuration: 0.5) {
                self.heartLikeTitle.tintColor = .red
                self.heartLikeTitle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.heartLikeTitle.transform = CGAffineTransform(rotationAngle: .pi)
//                self.heartLikeTitle.center.x += 200
                self.heartLikeTitle.transform = .identity
            }
            
            let center = CABasicAnimation(keyPath: "center.x")
            center.toValue = 200
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 1
            animationGroup.fillMode = .forwards
            animationGroup.animations = [center]
            heartLikeTitle.layer.add(animationGroup, forKey: nil)
        } else {
            self.heartLikeTitle.tintColor = .blue
            UIView.animateKeyframes(withDuration: 2,
                                    delay: 0,
                                    options: .autoreverse,
                                    animations: {
                                        UIView.addKeyframe(
                                            withRelativeStartTime: 0,
                                            relativeDuration: 0.25) {
                                                self.heartLikeTitle.center.x += 40
                                        }
                                        
                                        UIView.addKeyframe(
                                            withRelativeStartTime: 0.20,
                                            relativeDuration: 1) {
                                                self.heartLikeTitle.transform = CGAffineTransform(scaleX: 0.5,
                                                                                                  y: 0.5)
                                                
                                        }
                                        self.heartLikeTitle.transform = .identity
            },
                                    completion: nil)
            likeCountTitle.text = "0"
        }
    }
    
    @objc func tapToImage() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: [.autoreverse],
                       animations: { [unowned self] in
                        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        self.animateImageView.transform = scale
        }) { [unowned self] _ in
            self.animateImageView.transform = .identity
        }
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
