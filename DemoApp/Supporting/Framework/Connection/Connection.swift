//
//  Connection.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Alamofire
import Combine

/// The states of the connection
public enum NetworkConnectionState {
    case connected
    case notConnected
}

/// The errors from Connection class
public enum ConnectionError: Error {
    case monitoringFailed
    public var localizedDescription: String {
        switch self {
        case .monitoringFailed:
            return "Network monitoring failed."
        }
    }
}

/// Manager that listen for the network connection states
public final class Connection {
    
    /// the shared instance
    public static let shared = Connection()
    
    /// The reachability manager from Alamofire
    private var networkReachability: NetworkReachabilityManager?
    
    /// The connection state that we will listen to knwo abouut network state changes
    public let connectionSate = CurrentValueSubject<NetworkConnectionState, Never>(.connected)
    
    /// Flag to get the current reachability status
    public var isReachable: Bool { isConnected() }
    
    /// Initializer
    private init() { self.networkReachability = NetworkReachabilityManager.default }
    
    /// Listen and observe for the network state changes
    public func observe() {
        
        guard let networkReachability = networkReachability else {
            assertionFailure(ConnectionError.monitoringFailed.localizedDescription)
            return
        }
        
        //start the listener
        networkReachability.startListening { [unowned self](state) in
            switch state {
            case .notReachable:
                self.connectionSate.send(.notConnected)
            default:
                self.connectionSate.send(.connected)
            }
        }
    }
    
    /// Method that will check if the connection is connected or not
    private func isConnected() -> Bool {
        guard let networkReachability = networkReachability else {
            assertionFailure(ConnectionError.monitoringFailed.localizedDescription)
            return true
        }
        return networkReachability.isReachable
    }
}
