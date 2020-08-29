//
//  NetworkServices + Ext.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 29.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

extension NetworkService {
    
    func fetchPhoto(_ url: String) {
        guard let urlRequest = URL(string: url) else { return }
        let request = URLRequest(url: urlRequest)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images[url] = image
                }
            }
        }.resume()
    }
    
    func setPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var imageView: UIImage?
        if let photo = images[url] {
            imageView = photo
        } else {
            fetchPhoto(url)
        }
        return imageView
    }
}

