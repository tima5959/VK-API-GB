//
//  Photo.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 30.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    var sizes: [Sizes] = [Sizes]()
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Sizes: Object, Codable {
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
}
