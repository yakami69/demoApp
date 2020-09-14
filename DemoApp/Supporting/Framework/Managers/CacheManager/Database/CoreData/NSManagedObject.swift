//
//  NSManagedObject.swift
//  DBCheck
//
//  Created by Narendra Kathayat on 4/27/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import CoreData

extension CoreDataDatabase {
    
    /// Method to get the NSManagedObject from entity name and context
    /// - Parameters:
    ///   - entityName: the name of the entity
    ///   - context: the context
    private func getEntity(entityName: String, context: NSManagedObjectContext) throws -> NSManagedObject {
        guard let description = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw CacheError.invalidEntity(entityName: entityName)
        }
        let managedObject = NSManagedObject(entity: description, insertInto: context)
        return managedObject
    }
    
    /// Method to create the managedObject from dictionary
    /// - Parameter dictionary: the dictionary
    /// - Parameter entity: the name of the class
    /// - Parameter context: the context to insert
    func managedObject(_ dictionary: [String: Any], entity: String, context: NSManagedObjectContext) throws -> NSManagedObject {
        
        /// extract the class/entity name
        guard let objectId = dictionary["objectId"] as? String else {
            assertionFailure("The constraint attribute objectId should be present")
            throw CacheError.missingConstraint
        }
        
        /// first we get the object if already in database, this is possible from constraint by objectId
        let managedObject = try getManagedObject(entityName: entity, objectId: objectId, context: context)
        
        /// populate the data
        populate(parentObject: managedObject, dictionary: dictionary)
        
        /// return the object
        return managedObject
    }
    
    /// Method to get the already saved object with the entity name and object id, or create new if not present
    /// - Parameters:
    ///   - entityName: the entityname
    ///   - objectId: the object id to identify that object
    ///   - context: the context to search
    private func getManagedObject(entityName: String, objectId: String, context: NSManagedObjectContext) throws -> NSManagedObject {
        
       /// first we check if the object is already in DB
        let predicate =  NSPredicate(format: "objectId == %@", objectId)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        let savedObject = try context.fetch(fetchRequest).first
        
        if let savedObject = savedObject {
            return savedObject
        } else {
            let newObject = try getEntity(entityName: entityName, context: context)
            return newObject
        }
    }
    
    /// Method to populate data in the managedObject
    /// - Parameter parentObject: the manged object to be populated with data from dictionary
    /// - Parameter dictionary: the manged object key/value pair
    private func populate(parentObject: NSManagedObject, dictionary: [String: Any]) {
        guard let context = parentObject.managedObjectContext else {
            assertionFailure("ManagedObjectContext is missing somehow")
            return
        }
        
        do {
            for (key, value) in dictionary {
                if let dictionaryValue = value as? [String: Any] {
                    let object = try managedObject(dictionaryValue, entity: entityName(forKey: key), context: context)
                    parentObject.setValue(object, forKey: key)
                } else if let arrayValue = value as? [[String: Any]] {
                    let mutableSet = parentObject.mutableSetValue(forKey: key)
                    for dictionaryValue in arrayValue {
                        let object = try managedObject(dictionaryValue, entity: entityName(forKey: key), context: context)
                        mutableSet.add(object)
                    }
                } else {
                    let srializedValue = serializeToValidObject(key: key, value: value)
                    parentObject.setValue(srializedValue, forKey: key)
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
