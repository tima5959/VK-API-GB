//
//  NewsViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 31.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    var model: [NewsFeedModel] = []
    private let networkService = NetworkService()
    private let customRefreshControll = UIRefreshControl()
    
    // Create my own operation queue
    // Создаел свою очередь операции
    private let operationQ = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Новости"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        customRefreshControll.addTarget(self, action: #selector(getter: refreshControl), for: .allEvents)
        tableView.refreshControl = customRefreshControll
        
//        fetchNews()
//        fetchNewsOperations()
        operationsMethods()
    }
    
    private func operationsMethods() {
        let fetchNewsData = NetworkAsyncOperation()
        operationQ.addOperation(fetchNewsData)
        
        let parseCommunitiesOperation = ParseCommunitiesOperation()
        parseCommunitiesOperation.addDependency(fetchNewsData)
        operationQ.addOperation(parseCommunitiesOperation)
        
        let reloadDataOperation = ReloadTableController(self)
        reloadDataOperation.addDependency(parseCommunitiesOperation)
        operationQ.addOperation(reloadDataOperation)
    }
    
    // MARK: Asyncronology fetch with Operations
    private func fetchNewsOperations() {
        // создал экземпляр операции
        let operation = NetworkOperation()
        operation.completionBlock = {
            DispatchQueue.main.async {
                self.model = operation.model
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        // добавил в свою очередь операции экземпляр операции выше
        operationQ.addOperation(operation)
    }
    
    // MARK: Asyncronology fetch with GCD
    private func fetchNews() {
        DispatchQueue.global().async {
            self.networkService.getNews({ [weak self] (news) in
                guard let self = self else { return }
                self.model = news
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }) { [unowned self] _ in
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    @objc func refreshControllAction() {
//        fetchNews()
        fetchNewsOperations()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let news = model[indexPath.row]
        let height = calculateImageHeight(news)
        
        cell.configureCell(byData: news,
                           contentPhotoHeight: height,
                           networkService: networkService)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
        
        let calculatedPhotoHeight = tableView.frame.width / ratio
        return calculatedPhotoHeight
    }
}
