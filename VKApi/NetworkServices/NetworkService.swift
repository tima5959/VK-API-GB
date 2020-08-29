//
//  NetworkService.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 13.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    
    private let session = URLSession(configuration: .default)
    
    private let userID = Session.shared.userId
    private var urlComponents = URLComponents()
    private let scheme = "https"
    private let version = "5.122"
    private let autorizeHost = "oauth.vk.com"
    private let vkApiHost = "api.vk.com"
    
    var images = [String: UIImage]()
    
    func getAuthorized() -> URLRequest {
        urlComponents.scheme = scheme
        urlComponents.host = autorizeHost
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            .init(name: "client_id", value: "7566637"),
            .init(name: "display", value: "mobile"),
            .init(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            .init(name: "scope", value: "262150"),
            .init(name: "response_type", value: "token"),
            .init(name: "v", value: version)
        ]
        guard let url = urlComponents.url else { preconditionFailure( "URL was bady formatted") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getLoadFriends(handler: @escaping ([Friend]) -> Void) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            .init(name: "user_ids", value: "\(userID)"),
            .init(name: "order", value: "hints"),
            .init(name: "fields", value: "sex, bdate, city, country, photo_100, photo_200_orig"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version)
        ]
        guard let url = urlComponents.url else { preconditionFailure("loadFriends network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            guard let friendsModelData = try? JSONDecoder().decode(Response<Friend>.self, from: data).response.items else { return }
            
//                guard let data = friendsModelData else { return }
                DispatchQueue.main.async {
                    handler(friendsModelData)
            }
        }.resume()
    }
    
    func getLoadGroups(handler: @escaping ([Groups]) -> Void) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            .init(name: "user_ids", value: "\(userID)"),
            .init(name: "extended", value: "1"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("loadGroups network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            do {
                let groupsModelData = try? JSONDecoder().decode(Response<Groups>.self, from: data).response.items
                guard let groups = groupsModelData else { return }
                DispatchQueue.main.async {
                    handler(groups)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getFindGroups(title forFind: String) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            .init(name: "q", value: "\(forFind)"),
            .init(name: "sort", value: "0"),
            .init(name: "access_token", value: "\(Session.shared.token)"),
            .init(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("findGroups network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "")
        }.resume()
    }
    
}
