//
//  AsyncOperation.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 18.09.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

// MARK: - AsyncOperation
class AsyncOperation: Operation {
    
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
}

// MARK: - NetworkAsyncOperation
class NetworkAsyncOperation: AsyncOperation {
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    private let userID = Session.shared.userId
    private var urlComponents = URLComponents()
    private let scheme = "https"
    private let vkApiHost = "api.vk.com"
    private let version = "5.122"
    private let autorizeHost = "oauth.vk.com"
    
    var newsCommunities: Data?
    
    override func main() {
        fetchCommunities()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    private func fetchCommunities() {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            .init(name: "start_from", value: "next_from"),
            .init(name: "filters", value: "post"),
            .init(name: "max_photos", value: "0"),
            .init(name: "count", value: "20"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            self.newsCommunities = data
            self.state = .finished
        }.resume()
    }
}

// MARK: - ParseCommunitiesOperation
class ParseCommunitiesOperation: Operation {
    
    var parseData: [NewsFeedModel]?
    
    override func main() {
        parseNews()
    }
    
    private func parseNews() {
        guard let dependenci = dependencies.first as? NetworkAsyncOperation,
            let data = dependenci.newsCommunities else { return }
        
        do {
            var news = try JSONDecoder()
                .decode(Response<NewsFeedModel>.self, from: data)
                .response
                .items
            let groups = try JSONDecoder()
                .decode(ResponseNews.self, from: data)
                .response?
                .groups
            let friends = try JSONDecoder()
                .decode(ResponseNews.self, from: data)
                .response?
                .profiles
            
            for i in 0..<news.count {
                if news[i].sourceID ?? 0 < 0 {
                    guard let group = groups?.first(where: { $0.id == -news[i].sourceID! }) else { return }
                    news[i].avatarURL = group.avatarURL
                    news[i].name = group.name
                } else if news[i].sourceID ?? 0 > 0 {
                    guard let friend = friends?.first(where: { $0.id == news[i].sourceID }) else { return }
                    news[i].avatarURL = friend.avatarURL
                    news[i].name = "\(friend.firstName ?? "Username")" + " " + "\(friend.lastName ?? " ")"
                }
            }
            parseData = news
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - ReloadTableController
class ReloadTableController: Operation {
    
    var controller: NewsViewController
    
    init(_ controller: NewsViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseCommunitiesData = dependencies.first as? ParseCommunitiesOperation,
            let data = parseCommunitiesData.parseData else { return }
        OperationQueue.main.addOperation {    
            self.controller.model = data
            self.controller.tableView.reloadData()
        }
        
    }
    
}