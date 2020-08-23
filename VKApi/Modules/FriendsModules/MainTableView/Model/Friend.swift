//
//  Friend.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Friend: Object, Codable {
    
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var avatarURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarURL = "photo_100"
    }
    
    convenience init(id: Int, firstName: String, lastName: String, avatarURL: String) {
        self.init()
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var titleFirstLetter: String {
        return String(self.firstName[self.firstName.startIndex]).uppercased()
    }
}
