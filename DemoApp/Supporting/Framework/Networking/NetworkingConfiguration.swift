//
//  NetworkingConfiguration.swift
//  
//
//  Created by Narendra Bdr Kathayat on 1/29/20.
//

import Foundation

/// The configuration required for Networking
public struct NetworkingConfiguration {
    
    /// The client to use
    let client: Client
    
    /// The TokenManager
    let tokenManager: TokenManager
    
    /// The CacheManager
    let cacheManager: CacheManager
}
