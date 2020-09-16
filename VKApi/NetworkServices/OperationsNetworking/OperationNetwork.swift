//
//  OperationNetwork.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.09.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

class NetworkOperation: Operation {
    static let shared = NetworkService()
    
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    private let userID = Session.shared.userId
    private var urlComponents = URLComponents()
    private let scheme = "https"
    private let vkApiHost = "api.vk.com"
    private let version = "5.122"
    private let autorizeHost = "oauth.vk.com"
    
    var data: Data?
    
    override func main() {
        if isCancelled {
            return
        }
        
        getNews(data)
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    // MARK: - Find communities request
    func getNews(_ newsData: Data?) -> Void {
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
        
        if isCancelled {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let datas = data else { return }
            self.data = datas
        }
        task?.resume()
    }
}

class ParseOperation: Operation {
    
    var data: Data?
    var model: [NewsFeedModel]?
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let networkOperation = dependencies.first as? NetworkOperation,
            let data = networkOperation.data else { return }
        
        var news = try? JSONDecoder()
            .decode(Response<NewsFeedModel>.self, from: self.data!)
            .response
            .items
        
        
        let groups = try? JSONDecoder()
            .decode(ResponseNews.self, from: data)
            .response?
            .groups
        
        let friends = try? JSONDecoder()
            .decode(ResponseNews.self, from: data)
            .response?
            .profiles
        
        for i in 0..<news!.count {
            if news![i].sourceID ?? 0 < 0 {
                guard let group = groups?.first(where: {
                    $0.id == -news![i].sourceID!
                }) else { return }
                
                news![i].avatarURL = group.avatarURL
                news![i].name = group.name
                
            } else if news![i].sourceID ?? 0 > 0 {
                guard let friend = friends?.first(where: {
                    $0.id == news![i].sourceID
                }) else { return }
                
                news![i].avatarURL = friend.avatarURL
                news![i].name = "\(friend.firstName ?? "Username")" + " " + "\(friend.lastName ?? " ")"
            }
        }
        self.model = news
    }
    
    
}


