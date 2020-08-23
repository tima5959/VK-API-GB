//
//  RealmService.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 20.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    
    
    static func saveInRealm<T: Object>(items: [T],
                                       config: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                                       updatePolicy: Realm.UpdatePolicy = .modified) {
        
        NetworkService.shared.getLoadFriends { friend in
            do {
                let realm = try Realm(configuration: self.deleteIfMigration)
                try realm.write {
                    realm.add(items, update: updatePolicy)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    static func fetchByRealm<T: Object>(
        items: T.Type,
        config: Realm.Configuration = Realm.Configuration.defaultConfiguration
    ) throws -> Results<T> {
        let realm = try Realm(configuration: self.deleteIfMigration)
        return realm.objects(items)
    }
    
}
