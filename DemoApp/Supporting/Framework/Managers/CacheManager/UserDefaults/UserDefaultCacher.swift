//
//  UserDefaultCacher.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/1/19.
//

import Foundation

/// The cacher that will cache and retrive object from the UserDefaults
final class UserDefaultCacher: CacheManageable {
    
    //givce acces to another module as well
    public init() {}
    
    /// Save the data
    /// - Parameter objectData: the data to save
    /// - Parameter key: the key associated
    @discardableResult
    func saveData(objectData: Data, withKey key: CacheKeyable, completion: SaveResult? = nil) -> Bool {
        UserDefaults.standard.setValue(objectData, forKey: key.name)
        return UserDefaults.standard.synchronize()
    }
    
    /// Get the data
    /// - Parameter key: the associated key
    func getData<O>(type: O.Type, forKey key: CacheKeyable) -> O? {
        return UserDefaults.standard.object(forKey: key.name) as? O
    }
    
    /// Get the value for a given key
    /// - Parameter forKey: the storage key
    func getValue(forKey key: CacheKeyable) -> Any? {
        return UserDefaults.standard.value(forKey: key.name)
    }
    
    /// Sets the value into keychain for a given key
    /// - Parameters:
    ///   - value: the value to store
    ///   - key: the key for the storage
    @discardableResult
    func saveValue(value: Any, forKey key: CacheKeyable) -> Bool {
        UserDefaults.standard.setValue(value, forKey: key.name)
        return UserDefaults.standard.synchronize()
    }
    
    /// Deletes a object from cache with the given key
    /// - Parameter key: the key of the stored object
    @discardableResult
    func delete(forKey key: CacheKeyable) -> Bool {
        UserDefaults.standard.removeObject(forKey: key.name)
        return UserDefaults.standard.synchronize()
    }
}
