//
//  Groups.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

struct Groups: Codable, CustomStringConvertible {
    var description: String {
        return "id =\(id), name = \(name), url = \(avatarURL)"
        }
    
    var id: Int = 0
    var name: String = ""
    var avatarURL: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
}

