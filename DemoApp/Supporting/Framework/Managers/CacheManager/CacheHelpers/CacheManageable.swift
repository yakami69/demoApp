//
//  CacheManageable.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/1/19.
//

import Foundation

/// Alias for the save completion
public typealias SaveResult = (_ success: Bool,_ error: CacheError) -> Void

/// The protocol inherited by the cache mechanism
protocol CacheManageable {
    func saveData(objectData: Data, withKey key: CacheKeyable, completion: SaveResult?) -> Bool
    func getData<O>(type: O.Type, forKey key: CacheKeyable) -> O?
    func delete(forKey key: CacheKeyable) -> Bool
    func saveValue(value: Any, forKey key: CacheKeyable) -> Bool
    func getValue(forKey key: CacheKeyable) -> Any?
}

extension CacheManageable {
        
    func saveValue(value: Any, forKey key: CacheKeyable) -> Bool {
        fatalError("Please implement before using these methods")
    }
    
    func getValue(forKey key: CacheKeyable) -> Any? {
        fatalError("Please implement before using these methods")
    }
    
    func save(data: Data, table: String, completion: @escaping SaveResult) {
        fatalError("Please implement before using these methods")
    }
}

/// This protocol will be conformed by caheKey enum implimentations
public protocol CacheKeyable {
    var name: String { get }
}
