//
//  PhotoService.swift
//  VKApi
//
//  Created by Tim on 28.10.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class PhotoService {
    
    let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    var images = [String: UIImage]()
    
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(tableView: container)
    }
    
    init(container: UICollectionView) {
        self.container = Collection(collectionView: container)
    }
    
    // Путь хранения изображений в песочнице
    private static let pathName: String = {
        // Создаю название для директории
        let pathName = "images"
        
        // Проверяю есть ли доступ к директории кеша
        guard let cacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first else {
            return pathName
        }
        
        // Создаю URL из названия директории
        let url = cacheDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        // Проверяю есть ли директория по такому пути URL
        // Создаю директории если таковой нет
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(_ url: String) -> String? {
        // Проверяю есть ли доступ к директории кеша
        guard let cacheDirectory = FileManager
                .default
                .urls(for: .cachesDirectory,
                      in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        
        return cacheDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(_ url: String, image: UIImage) {
        guard let filePathName = getFilePath(url),
              let fileData = image.pngData()
        else {
            return
        }
        
        FileManager.default.createFile(atPath: filePathName,
                                       contents: fileData,
                                       attributes: nil)
    }
    
    private func getImageFromCache(_ url: String) -> UIImage? {
        guard let filePathName = getFilePath(url),
              let info = try? FileManager.default.attributesOfItem(atPath: filePathName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else {
            return nil
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: filePathName) else {
            return nil
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.images[url] = image
        }
        
        return image
    }
    
    private func loadPhoto(atIndexPath: IndexPath, byUrl: String) {
        guard let url = URL(string: byUrl) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.images[byUrl] = image
            }
            
            self.saveImageToCache(byUrl, image: image)
            DispatchQueue.main.async { [unowned self] in
                self.container.reloadRow(atIndexPath: atIndexPath)
            }
        }.resume()
    }
    
    func getImage(atIndexPath: IndexPath, byUrl: String) -> UIImage? {
        var image: UIImage?
        
        if let photo = images[byUrl] {
            image = photo
        } else if let photo = getImageFromCache(byUrl) {
            image = photo
        } else {
            loadPhoto(atIndexPath: atIndexPath, byUrl: byUrl)
        }
        
        return image
    }
}

private protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

extension PhotoService {
    private class Table: DataReloadable {
        var tableView: UITableView
        
        init(tableView: UITableView) {
            self.tableView = tableView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        
        var collectionView: UICollectionView
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
}
