//
//  CoreDataDatabase.swift
//  Place
//
//  Created by Narendra Kathayat on 3/17/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation
import CoreData

/// The helper object for  database
public struct DatabaseHelper {
    
    /// The modelName for database file
    var modelName: String
    
    /// The URL of the database file
    var modelURL: URL
    
    /// The actual entiy name identifier
    var entityIdentifiers: [String: String]
}

/// The type of database we use
public enum DatabaseType {
    case coreData(DatabaseHelper)
}

/// The database protocol
protocol Database {
    
    /// The context to use for data in DB, specificalaly for core data
    var context: NSManagedObjectContext! { get }
    
    /// Method to perform the data insert and save on the DB
    /// - Parameters:
    ///   - data: the data that needs to be saved
    ///   - entity: the entityName
    ///   - context: the context to insert to
    ///   - completion: completion handler
    func saveData(data: Data, entity: String, completion: SaveResult?)
}

public final class CoreDataDatabase: Database {
    
    /// The shared instance
    public static let shared = CoreDataDatabase()
    private init() {}
    
    /// The name for the DB file
    private var modelName: String!
    
    /// The modelurl for DB file
    private var modelURL: URL!
    
    /// The key/value for identifiying the database entity name
    private var entityIdentifier: [String: String] = [:]
    
    /// Initializer
    func initialize(name: String, modelURL: URL, entityIdentifier: [String: String]) {
        self.modelName = name
        self.modelURL = modelURL
        self.entityIdentifier = entityIdentifier
        self.loadDB()
    }
    
    /// The persistent container
    private var persistentContainer: NSPersistentContainer!
    
    /// The main context
    public lazy var context: NSManagedObjectContext! = {
        guard let container = persistentContainer else { fatalError("Container not loaded.") }
        let context = Thread.isMainThread ? container.viewContext : container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    // method to load the database
    private func loadDB() {
        
        /// check we can load the model
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            assertionFailure("Model cannot be loaded from url \(modelURL?.absoluteString ?? "")")
            return
        }
        
        /// check we have model name
        guard let name = modelName, !name.isEmpty else {
            assertionFailure("Model name should not be nil or empty")
            return
        }
        
        /// initialize
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        
        /// set the description
        let sqliteURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(name).sqlite")
        let storeDirectory =  sqliteURL
        let description = NSPersistentStoreDescription(url: storeDirectory)
        persistentContainer.persistentStoreDescriptions = [description]
        
        /// load the container
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                assertionFailure("Unable to load persistent container \(error.localizedDescription)")
            } else {
                debugPrint(description)
            }
        }
    }
    
    /// Method to find the entity name in the identifier dictionary for given key
    /// - Parameter key: the key
    func entityName(forKey key: String) -> String {
        guard let entityName = entityIdentifier[key] else {
            fatalError("The entity corresponding to key '\(key)' not found.")
        }
        return entityName
    }
    
    /// serialize some object that cannot be directly inserted in DB like date in Dictionary
    /// - Parameters:
    ///   - key: the dictionary key
    ///   - value: the value of the key
    func serializeToValidObject(key: String, value: Any) -> Any {
        if key.lowercased().contains("date"), let dateString = value as? String, let format = entityIdentifier["format"] {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            guard let date = formatter.date(from: dateString) else {
                fatalError("The date format is wrong. unable to convert to date")
            }
            return date
        }
        return value
    }
}

extension CoreDataDatabase {
    
    /// Method to perform the data insert and save on the DB
    /// - Parameters:
    ///   - data: the data that needs to be saved
    ///   - entity: the entityName
    ///   - completion: completion handler
    func saveData(data: Data, entity: String, completion: SaveResult?)  {
        
        /// check for valid context
        guard let context = self.context else {
            completion?(false, .missingContext)
            return
        }
        
        do {
            /// searialize to the key-value objects
            let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            /// check the type of data structure and build the managedObject graph
            if let result = object as? [String: Any] {
                _ = try managedObject(result, entity: entity, context: context)
                
            } else if let results = object as? [[String: Any]] {
                for result in results {
                    _ = try managedObject(result, entity: entity, context: context)
                }
            } else {
                completion?(false, .invalidDataStructure)
                return
            }
            
            // finally saev the context
            context.save(completion: completion)
            
        } catch {
            completion?(false, .failure(error))
        }
    }
}
