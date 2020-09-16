//
//  NewsViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 31.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    private let network = NetworkService()
    private var model: [NewsFeedModel] = []
    
    private let customRefreshControll = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        customRefreshControll.addTarget(self, action: #selector(getter: refreshControl), for: .allEvents)
        tableView.refreshControl = customRefreshControll
        
//        fetchNews()
        fetchNewsOperation()
    }
    
    private func fetchNewsOperation() {
        let fetchingQ = OperationQueue()
//        fetchingQ.maxConcurrentOperationCount = 5
        fetchingQ.name = "fetch operation queue"
        
        let networkOperation = NetworkOperation()
        networkOperation.completionBlock = { [weak self] in
            guard let self = self else { return }
            let operationData = networkOperation.model
            DispatchQueue.main.async {
                self.model = operationData
                self.tableView.reloadData()
            }
        }
        
        fetchingQ.addOperation(networkOperation)
        
//        let parseOperation = ParseOperation()
//        parseOperation.addDependency(networkOperation)
//        parseOperation.completionBlock = { [weak self] in
//            guard let self = self else { return }
//            guard let model = parseOperation.model else { return }
//            self.model = model
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.tableView.refreshControl?.endRefreshing()
//            }
//        }
        
//        fetchingQ.addOperations([networkOperation,parseOperation], waitUntilFinished: false)
    }
    
    private func fetchNews() {
        DispatchQueue.global().async {
            self.network.getNews({ [weak self] (news) in
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
        fetchNews()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.configure(model, at: indexPath)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
