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
    private let vkApiHost = "api.vk.com"
    private let version = "5.122"
    private let autorizeHost = "oauth.vk.com"
    
    var images = [String: UIImage]()
    
    // MARK: - Authorized request
    func getAuthorized() -> URLRequest {
        urlComponents.scheme = scheme
        urlComponents.host = autorizeHost
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            .init(name: "client_id", value: "7566637"),
            .init(name: "display", value: "mobile"),
            .init(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            .init(name: "scope", value: "401502"),
            .init(name: "response_type", value: "token"),
            .init(name: "v", value: version)
        ]
        guard let url = urlComponents.url else { preconditionFailure( "URL was bady formatted") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    // MARK: - Fetch friends request
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
            guard let data = data,
                let friendsModelData = try? JSONDecoder().decode(Response<Friend>.self, from: data).response.items else { return }
            DispatchQueue.main.async {
                handler(friendsModelData)
            }
        }.resume()
    }
    
    // MARK: - Fetch communities request
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
            
            guard let data = data,
                let groups = try? JSONDecoder().decode(Response<Groups>.self, from: data).response.items else { return }
            DispatchQueue.main.async {
                handler(groups)
            }
        }.resume()
    }
    
    
    // MARK: - Fetch all photos request
    func fetchAllPhoto(user id: Int?, _ completionHandler: @escaping ([Photo]) -> Void, _ completionError: @escaping (String?) -> Void) {
        guard let id = id else { return }
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            .init(name: "owner_id", value: String(id)),
            .init(name: "extended", value: "0"),
            .init(name: "photo_sizes", value: "0"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("fetch all photo is failure") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let photo = try JSONDecoder().decode(Response<Photo>.self, from: data).response.items
                DispatchQueue.main.async {
                    completionHandler(photo)
                }
            } catch let error {
                completionError(error.localizedDescription)
            }
        }.resume()
        
    }
    
    // MARK: - Fetch all photos request
    func findGroups(_ text: String, completionHandler: @escaping ([Groups]) -> Void) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            .init(name: "q", value: text),
            .init(name: "type", value: "group"),
            .init(name: "sort", value: "0"),
            .init(name: "access_token", value: Session.shared.token),
            .init(name: "v", value: version)
        ]
        
        guard let url = urlComponents.url else { preconditionFailure("group search error \(#function) \(#file)")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data, let groups = try? JSONDecoder().decode(Response<Groups>.self, from: data).response.items else { return }
            DispatchQueue.main.async {
                completionHandler(groups)
            }
        }.resume()
    }
    
    // MARK: - Find communities request
    func getFindGroups(title forFind: String) {
        urlComponents.scheme = scheme
        urlComponents.host = vkApiHost
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            .init(name: "q", value: forFind),
            .init(name: "sort", value: "0"),
            .init(name: "access_token", value: Session.shared.token),
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
    
    // MARK: - Find communities request
    func getNews(_ completionHandler: @escaping ([NewsFeedModel]) -> Void,
                 _ completionError: @escaping (Bool) -> Void) {
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
        
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let news = try JSONDecoder().decode(Response<NewsFeedModel>.self,
                                                     from: data).response.items
                //            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                DispatchQueue.main.async {
                    completionHandler(news)
                }
            } catch let error {
                completionError(true)
            }
        }.resume()
    }
}
