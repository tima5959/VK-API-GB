//
//  NetworkService.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 13.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    private let session = Session()
    private let userID = Session.shared.userId
    private let token = Session.shared.token
    private var urlComponents = URLComponents()
    private let scheme = "https"
    private let version = "5.122"
    private let autorizeHost = "oauth.vk.com"
    private let vkApiHost = "api.vk.com"
    
    func getAuthorized() -> URLRequest {
        urlComponents.scheme = scheme
        urlComponents.host = autorizeHost
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7566637"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: version)
        ]
        guard let url = urlComponents.url else { preconditionFailure( "URL was bady formatted") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getLoadFriends() {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_ids", value: "\(userID)"),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "fields", value: "nickname, domain, sex, bdate, city, country, timezone, online, last_seen"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("loadFriends network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "")
        }
        task.resume()
    }
    
    func getLoadGroups() {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_ids", value: "\(userID)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "filter", value: "admin, editor, moder, advertiser, groups, publics, events, hasAddress"),
            URLQueryItem(name: "fields", value: "city, country, place, description, members_count, counters, status, contacts, verified"),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("loadGroups network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "")
        }
        task.resume()
    }
    
    func getFindGroups(title forFind: String) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(forFind)"),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("findGroups network methods is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "")
        }
        task.resume()
    }
    
    func getPhotos(_ ownerID: Int?) {
        guard let owner = ownerID else { return }
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/photos.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_ids", value: "\(userID)"),
            URLQueryItem(name: "owner_id", value: String(owner)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "v", value: version),
        ]
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "")
        }
        task.resume()
    }
    
}
