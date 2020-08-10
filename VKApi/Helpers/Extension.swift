//
//  Extension.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 27.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit


public func setShadow(_ view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = .zero
}

public func setShadowForImageView(_ view: UIView) {
    let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    view.layer.masksToBounds = false
    view.layer.cornerRadius = 60
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.5
}


public func setCornerRadius(_ view: [UIView], radius: CGFloat) {
    
    view.forEach { (view) in
         view.layer.masksToBounds = false
         view.layer.cornerRadius = radius
    }
}

public func setAlphaAnimation(_ view: UIView, _ beginTime: CFTimeInterval) {
    UIView.animate(withDuration: 0.5,
                   delay: beginTime,
                   options: [.autoreverse, .repeat],
                   animations: {
                    view.alpha = 0.1
    })
    
//    let animation = CABasicAnimation(keyPath: "backgroundColor")
//    animation.beginTime = CACurrentMediaTime() + beginTime
//    animation.fromValue = UIColor(cgColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
//    animation.toValue = UIColor(cgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//    animation.duration = 0.5
//    view.layer.add(animation, forKey: nil)
}
