//
//  Response.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 16.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

class Response<T: Codable>: Codable {
    let response: Items<T>
    let profiles: [Friend]? = []
    let groups: [Groups]? = []
    let next_from: String? = ""    
}

class Items<T: Codable>: Codable {
    let items: [T]
}
