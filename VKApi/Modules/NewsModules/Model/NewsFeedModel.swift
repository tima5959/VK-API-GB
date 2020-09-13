//
//  NewsFeedModel.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 06.09.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ResponseNews: Codable {
    let response: ItemsNews?
}

// MARK: - Response
struct ItemsNews: Codable {
    let items: [NewsFeedModel]?
    let profiles: [ProfileNews]?
    let groups: [GroupNews]?
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsFeedModel: Codable {
    let sourceID: Int?
    let date: Int
    let type: String
    let postType: String?
    let text: String?
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Comments
    let isFavorite: Bool?
    let postID: Int?
    
    var name: String?
    var avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        case type
        case postType = "post_type"
        case text, attachments, comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
    }
    
    func publicationTime(timeIntervalSince1970: Int) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.timeZone = .current
        let date = Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
        
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String?
    let photo: Photos?
}

// MARK: AttachmentPhotos
struct Photos: Codable {
    let date: Int?
    let id: Int?
    let ownerID: Int?
    let accessKey: String?
    let sizes: [Size]?
    let text: String?
    let userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case date, id
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case sizes, text
        case userID = "user_id"
    }
}

// MARK: AttachmentPhotosSize
struct Size: Codable {
    let url: String?
    let type: String?
}

// MARK: - Comments
struct Comments: Codable {
    let count: Int
}

// MARK: - Likes
struct Likes: Codable {
    let count: Int
    let userLikes: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count: Int
    let userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Group
struct GroupNews: Codable {
    let id: Int?
    let name: String?
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
}

// MARK: - Profile
struct ProfileNews: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}
