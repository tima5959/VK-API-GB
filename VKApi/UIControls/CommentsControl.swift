//
//  CommentsControl.swift
//  VKApi
//
//  Created by Tim on 07.11.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class CommentsControl: UIControl {

    private var count = 0
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.image = UIImage(systemName: "message")
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        setupView()
        setupConstraints()
        
    }
    
    func set(_ count: Int) {
        self.count = count
        setupView()
    }
    
    private func setupView() {
        self.addTarget(self, action: #selector(tapToControl), for: .touchUpInside)
        countLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        switch count {
        case 0..<1_000:
            countLabel.text = String(count)
        case 1_000..<1_000_000:
            countLabel.text = String("\(count / 1000)" + "K")
        default:
            countLabel.text = "-"
        }
    }
    
    @objc func tapToControl() {
        
    }
    
    private func setupConstraints() {
        self.addSubview(imageView)
        self.addSubview(countLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true;
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true;
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true;
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true;
        
        countLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0).isActive = true;
        countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true;
        countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true;
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true;
    }
}

