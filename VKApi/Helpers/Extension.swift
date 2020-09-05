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


public extension UIImageView {
    func loadImage(fromURL url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)

        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.transition(toImage: image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                        }
                    }
                }).resume()
            }
        }
    }
    // анимация изменения картинки
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}

extension UIView {
    public func setShadowAndCorner(_ imageView: UIImageView, radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, cornerRadius: CGFloat) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.opacity = opacity
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
}

class SCImageView: UIView {
    init(_ imageView: UIImageView, radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.opacity = opacity
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
