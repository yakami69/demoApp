//
//  Factory.swift
//
//
//  Created by Narendra Bdr Kathayat on 1/29/20.
//

import Foundation

public protocol Factory {
    associatedtype Instance
    static func get() -> Instance
}

// MARK: - Factory For Networking
public struct NetworkingFactory: Factory {
    
    /// The concrete type
    public typealias Instance = Networking
    
    /// Gets the instance of Networking
    public static func get() -> Networking {
        return Networking(configuration: NetworkingConfigFactory.get())
    }
}

// MARK: - Factory For AutoComplete Networking
public struct AutoCompleteNetworkingFactory: Factory {
    
    /// The concrete type
    public typealias Instance = Networking
    
    /// Gets the instance of Networking
    public static func get() -> Networking {
        return Networking(configuration: AutoNetworkingConfigFactory.get())
    }
}

// MARK: - Factory For UserDefaultCacheManager
public struct UserDefaultCacheManagerFactory: Factory {
    public typealias Instance = CacheManager
    public static func get() -> CacheManager {
        return CacheManager(type: .userDefault)
    }
}

// MARK: - Factory For KeychainCacheManager
public struct KeychainCacheManagerFactory: Factory {
    public typealias Instance = CacheManager
    public static func get() -> CacheManager {
        return CacheManager(type: .keychain)
    }
}

// MARK: - Factory For TokenManager
public struct TokenManagerFactory: Factory {
    public typealias Instance = TokenManager
    public static func get() -> TokenManager {
        return TokenManager(cacheManager: KeychainCacheManagerFactory.get())
    }
}


// MARK: - Factory For NetworkingConfiguration
public struct NetworkingConfigFactory: Factory {
    
    /// The concrete type
    public typealias Instance = NetworkingConfiguration
    
    /// get NetworkConfiguration
    public static func get() -> NetworkingConfiguration {
        return NetworkingConfiguration(client: ClientFactory.get(),
                                       tokenManager: TokenManagerFactory.get(),
                                       cacheManager: KeychainCacheManagerFactory.get())
    }
}

// MARK: - Factory For AutoNetworkingConfiguration
public struct AutoNetworkingConfigFactory: Factory {
    
    /// The concrete type
    public typealias Instance = NetworkingConfiguration
    
    /// get NetworkConfiguration
    public static func get() -> NetworkingConfiguration {
        return NetworkingConfiguration(client: AutoCompleteClientFactory.get(),
                                       tokenManager: TokenManagerFactory.get(),
                                       cacheManager: KeychainCacheManagerFactory.get())
    }
}

// MARK: - Factory For Client
public struct ClientFactory: Factory {
    
    /// The concrete type
    public typealias Instance = Client
    
    /// Get client
    public static func get() -> Client {
        return HttpClient(parser: ResponseParserFactory.get())
    }
}

// MARK: - Factory For Client
public struct AutoCompleteClientFactory: Factory {
    
    /// The concrete type
    public typealias Instance = Client
    
    /// Get client
    public static func get() -> Client {
        return HttpClient(parser: AutoCompleteResponseParserFactory.get())
    }
}

// MARK: - Factory For responseParser
public struct ResponseParserFactory: Factory {
    
    /// The concrete type
    public typealias Instance = ResponseParser
    
    /// get ResponseParser
    public static func get() -> ResponseParser {
        return ResponseParser(resultBuilder: ResultBuilderFactory.get())
    }
}

// MARK: - Factory For responseParser
public struct AutoCompleteResponseParserFactory: Factory {
   
    /// The concrete type
    public typealias Instance = AutoCompleteParser
    
    /// get ResponseParser
    public static func get() -> AutoCompleteParser {
        return AutoCompleteParser(resultBuilder: ResultBuilderFactory.get())
    }
}

// MARK: - Factory For ResultBuilder
public struct ResultBuilderFactory: Factory {
    
    /// The concrete type
    public typealias Instance = ResultBuilder
    
    /// Get ResultBuilder
    public static func get() -> ResultBuilder {
        return ResultBuilder()
    }
}
