//
//  Groups.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Groups: Object, Codable {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var avatarURL: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "photo_100"
    }
    
    convenience init(id: Int, name: String, avatarURL: String) {
        self.init()
        
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

