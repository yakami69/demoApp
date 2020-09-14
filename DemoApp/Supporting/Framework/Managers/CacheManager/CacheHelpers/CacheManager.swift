//
//  CacheManager.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/1/19.
//

import Foundation

/// The type of cache to use
public enum CacheType {
    case userDefault
    case keychain
    case database(DatabaseType)
}


/// Class that will manage the saving and retrieving of objects from given cacher
final public class CacheManager {
    
    /// The cacher that will be used for caching and retrieving cached data
    private let cacher: CacheManageable
    
    /// Initializer
    public init(type: CacheType) {
        switch type {
        case .userDefault:
            cacher = UserDefaultCacher()
        case .keychain:
            cacher = KeyChainCacher()
        case .database(let type):
            cacher = DatabaseCacher(type: type)
        }
    }
    
    /// Method to save a object of codable type
    /// - Parameter type: the object type
    /// - Parameter object: the object itself
    /// - Parameter key: the cache key
    @discardableResult
    public func saveObject<T: Codable>(type: T.Type, object: T, key: CacheKeyable, completion: SaveResult? = nil) -> Bool {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            let saved = cacher.saveData(objectData: data, withKey: key, completion: completion)
            return saved
        } catch {
            return false
        }
    }
    
    /// Method to retrive the codable object for a given ke=y
    /// - Parameter type: the type of object
    /// - Parameter key: the cache key
    public func getObject<T: Codable>(type: T.Type, forKey key: CacheKeyable) -> T? {
        guard let objectData = cacher.getData(type: Data.self, forKey: key) else { return nil }
        do {
            let object = try JSONDecoder().decode(T.self, from: objectData)
            return object
        } catch {
            return nil
        }
    }
    
    /// Method to save a object of generic type
    /// - Parameter type: the object type
    /// - Parameter object: the object itself
    /// - Parameter key: the cache key
    @discardableResult
    public func saveObject(data: Data, key: CacheKeyable, completion: SaveResult? = nil) -> Bool {
        let saved = cacher.saveData(objectData: data, withKey: key, completion: completion)
        return saved
    }
    
    /// Method to retrive the codable object for a given ke=y
    /// - Parameter type: the type of object
    /// - Parameter key: the cache key
    public func getObject<T>(type: T.Type, forKey key: CacheKeyable) -> T? {
        let object = cacher.getData(type: T.self, forKey: key)
        return object
    }
    
    /// Deletes the object from cache for given key
    /// - Parameter key: the key for object to remove
    public func delete(forKey key: CacheKeyable) -> Bool {
        return cacher.delete(forKey: key)
    }
    
    /// Set a generic value to the cache
    /// - Parameters:
    ///   - type: the type of value
    ///   - value: the actual value
    ///   - key: the key to store the value
    @discardableResult
    public func set<T>(_ type: T.Type, value: T, key: CacheKeyable) -> Bool {
        return cacher.saveValue(value: value, forKey: key)
    }
    
    /// get the value from the cache
    /// - Parameter key: the key to check in the cache
    public func get<T>(_ type: T.Type, forKey key: CacheKeyable) -> T? {
        guard let cachedResult = cacher.getValue(forKey: key) else { return nil }
        guard let value = cachedResult as? T else { return nil }
        return value
    }
}
