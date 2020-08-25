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
    let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
    var networking: NetworkService?
    
    init() {
        self.networking = NetworkService()
    }
        
    func fetchFriends(updatePolicy: Realm.UpdatePolicy = .modified) {
        networking?.getLoadFriends { data in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(data, update: updatePolicy)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchGroups(updatePolicy: Realm.UpdatePolicy = .modified) {
        networking?.getLoadGroups { data in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(data, update: updatePolicy)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveInRealm<T: Object>(items: [T],
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
    
    func fetchByRealm<T: Object>(
        items: T.Type,
        config: Realm.Configuration = Realm.Configuration.defaultConfiguration
    ) throws -> Results<T> {
        let realm = try Realm(configuration: self.deleteIfMigration)
        return realm.objects(items)
    }
    
}
