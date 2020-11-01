//
//  NewsCollectionViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 04.10.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NewsCollectionViewCell"

class NewsCollectionViewController: UICollectionViewController {
    
    var model: [NewsFeedModel] = []
    private let networkService = NetworkService()
    
    // Create my own operation queue
    // Создаел свою очередь операции
    private let operationQ = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        // Set up a 3-column Collection View
        let width = view.frame.size.width
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width:width, height:width)
        
        title = "Новости"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        operationsMethods()
    }
    
    private func operationsMethods() {
        let fetchNewsData = NetworkAsyncOperation()
        operationQ.addOperation(fetchNewsData)
        
        let parseCommunitiesOperation = ParseCommunitiesOperation()
        parseCommunitiesOperation.addDependency(fetchNewsData)
        operationQ.addOperation(parseCommunitiesOperation)
        
        let reloadDataOperation = ReloadCollectionController(self)
        reloadDataOperation.addDependency(parseCommunitiesOperation)
        operationQ.addOperation(reloadDataOperation)
    }
}

// MARK: UICollectionViewDataSource
extension NewsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! CellCollectionViewCell
        
        
        let news = model[indexPath.row]
        cell.configureCell(byData: news,
                           networkService: networkService,
                           imageHeight: calculateImageHeight(news))
    
        return cell
    }

    
}

extension NewsCollectionViewController {
    private func calculateImageHeight(_ news: NewsFeedModel) -> CGFloat {
        
        let contentData = news.attachments?.first?.photo?.sizes?.first
        
        guard let height = contentData?.height,
              let width = contentData?.width else {
            return 2
        }
        
        let photoHeight = height
        let photoWidth = width
        
        var ratio: CGFloat = 1.0000
        
        if photoHeight != 0 {
            ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
        }
        
        let calculatedPhotoHeight = collectionView.frame.width / ratio
        return calculatedPhotoHeight
    }

}
