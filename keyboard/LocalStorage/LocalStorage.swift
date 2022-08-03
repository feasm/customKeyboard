//
//  LocalStorage.swift
//  keysCustomKeyboardChallenge
//
//  Created by Felipe Alexander Da Silva Melo on 02/08/22.
//

import Foundation
import RealmSwift

final class LocalStorage {
    
    struct Error {
        static let saveError = "Error saving data on Realm"
        static let deleteError = "Error deleting data on Realm"
        static let getError = "Error getting data from Realm"
    }
    
    let realm: Realm?
    
    init() {
        realm = try? Realm()
    }
    
    func save<T: Object>(_ data: T) {
        guard let _ = realm?.objects(T.self) else { return }
        
        do {
            try self.realm?.write {
                self.realm?.add(data)
            }
        } catch {
            print(Error.saveError)
        }
    }
    
    func get<T: Object>() -> T? {
        let objects = realm?.objects(T.self)
        return objects?.first
    }
    
    func clear() {
        do {
            try self.realm?.write {
                self.realm?.deleteAll()
            }
        } catch {
            print(Error.deleteError)
        }
    }
    
}
