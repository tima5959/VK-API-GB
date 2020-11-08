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
    private var isLiked = false
    
    var imageLabel: UIImageView = {
        let label = UIImageView()
        label.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.image = UIImage(systemName: "heart")
        return label
    }()
    
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
    
    private func setView() {
        
        self.addTarget(self, action: #selector(tapToControl), for: .touchUpInside)
        
        setupLabels()
    }
    
    @objc func tapToControl() {
        isLiked.toggle()
        if isLiked {
            imageLabel.image = UIImage(systemName: "heart.fill")
            imageLabel.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            likeCount += 1
            setupLabels()
        } else {
            imageLabel.image = UIImage(systemName: "heart")
            likeCount -= 1
            imageLabel.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            setupLabels()
        }
    }
    
    private func setupLabels() {
        
        countLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        switch likeCount {
        case 0..<1_000:
            countLabel.text = String(likeCount)
        case 1_000..<1_000_000:
            countLabel.text = String("\(likeCount / 1000)" + "K")
        default:
            countLabel.text = "-"
        }
    }
    
    private func setupConstraints() {
        self.addSubview(imageLabel)
        self.addSubview(countLabel)
        
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true;
        imageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true;
        imageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true;
        imageLabel.widthAnchor.constraint(equalToConstant: 25).isActive = true;
        
        countLabel.leadingAnchor.constraint(equalTo: imageLabel.trailingAnchor, constant: 0).isActive = true;
        countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true;
        countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true;
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true;
    }
}
