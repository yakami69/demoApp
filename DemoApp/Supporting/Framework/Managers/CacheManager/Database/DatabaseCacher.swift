//
//  DatabaseCacher.swift
//  Place
//
//  Created by Narendra Kathayat on 3/17/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation
import CoreData

/// The DB Cacher
final class DatabaseCacher: CacheManageable {
    
    /// The requested database (mainly core data)
    private let database: Database
    
    /// Initialize the required database based on type
    init(type: DatabaseType) {
        switch type {
        case .coreData(let helper):
            let coreDB = CoreDataDatabase.shared
            coreDB.initialize(name: helper.modelName, modelURL: helper.modelURL, entityIdentifier: helper.entityIdentifiers)
            self.database = CoreDataDatabase.shared
        }
    }
    
    @discardableResult
    func saveData(objectData: Data, withKey key: CacheKeyable, completion: SaveResult? = nil) -> Bool {
        database.saveData(data: objectData, entity: key.name, completion: completion)
        return true
    }
    
    func getData<O>(type: O.Type, forKey key: CacheKeyable) -> O? {
        assertionFailure("For DB object use fetchrequest")
        return nil
    }
    
    @discardableResult
    func delete(forKey key: CacheKeyable) -> Bool {
        
        return false
    }
}
