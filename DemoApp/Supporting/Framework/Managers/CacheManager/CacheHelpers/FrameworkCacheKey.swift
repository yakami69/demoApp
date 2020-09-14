//
//  FrameworkCacheKey.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/1/19.
//

import Foundation

/// These are the cache keys used with the framework
public enum FrameworkCacheKey: String, CacheKeyable {
    case user
    case token
    case deviceId
    case appleUser
    
    public var name: String { return self.rawValue }
    public var entityName: String { return "" }
}
