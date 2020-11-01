//
//  HeartControl.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 06.10.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class HeartControl: UIControl {

    private var likeCount = 0
    var isLiked = false
    
    private var imageLabel = UIImageView()
    private var countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setView()
        setupConstraints()
    }
    
    func set(_ count: Int) {
        likeCount = count
        setView()
    }
    
    func setView() {
        imageLabel.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageLabel.image = UIImage(systemName: "heart")
        
        setupLabels()
    }
    
    private func setupLabels() {
        
        countLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        switch likeCount {
        case 0..<1_000:
            countLabel.text = String(likeCount)
        case 1_000..<1_000_000:
            countLabel.text = String("\(likeCount / 1000)" + "K")
        default:
            countLabel.text = "?"
        }
        
    }
    
    private func setupConstraints() {
        self.addSubview(imageLabel)
        self.addSubview(countLabel)
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true;
        imageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true;
        imageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true;
        
        countLabel.leadingAnchor.constraint(equalTo: imageLabel.trailingAnchor, constant: 8).isActive = true;
        countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true;
        countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true;
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true;
    }
}
