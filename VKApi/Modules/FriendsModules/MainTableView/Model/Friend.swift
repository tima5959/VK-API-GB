//
//  Friend.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

struct Friend: Codable, CustomStringConvertible {
    var description: String {
        return "id =\(id), name = \(firstName), last name = \(lastName), url = \(avatarURL)"
    }
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var avatarURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
}
