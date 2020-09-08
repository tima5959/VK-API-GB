//
//  Session.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 13.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation

class Session {
    static let shared = Session()
    
    var token: String = ""
    let userId: Int = 0
}
