//
//  KeyChainCacher.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/1/19.
//

import Foundation
import KeychainSwift

/// The cacher that will cache and retrive object from the UserDefaults
final class KeyChainCacher: CacheManageable {
    
    /// The keychain handler instance
    private static let keychain = KeychainSwift()
    
    //give acces to another module as well
    init() {}
    
    /// Save the data
    /// - Parameter objectData: the data to save
    /// - Parameter key: the key associated
    @discardableResult
    func saveData(objectData: Data, withKey key: CacheKeyable, completion: SaveResult? = nil) -> Bool {
        return KeyChainCacher.keychain.set(objectData, forKey: key.name)
    }
    
    /// Get the data
    /// - Parameter key: the associated key
    func getData<O>(type: O.Type, forKey key: CacheKeyable) -> O? {
        let data = KeyChainCacher.keychain.getData(key.name) as? O
        return data
    }
    
    /// Method to delete object from keychain based on given key
    /// - Parameter key: the key
    @discardableResult
    func delete(forKey key: CacheKeyable) -> Bool {
        return KeyChainCacher.keychain.delete(key.name)
    }
}
