//
//  Config.swift
//  
//
//  Created by Narendra Bdr Kathayat on 1/28/20.
//

import Foundation
import Alamofire

/// This config class will hold the configurations for the framework
class Config {
    
    /// The clientConfig
    var clientConfig: ClientConfig!
    
    /// The default networking headers
    private var defaultHeaders: [HTTPHeader] { [ HTTPHeader.contentType("application/json"), HTTPHeader.accept("application/json")] }
    
    /// Shared instance of the config
    static let `default` = Config()
    private init() {}
    
    /// Server URL for the API base
    lazy var serverURL: URL = {
        return clientConfig.environment.apiBaseURL
    }()

    /// google base URL
    lazy var googleAPIURL: URL = {
        return clientConfig.environment.googleBaseURL
    }()
    
    /// Builds default headers by appending any given header dictionary
    /// - Parameter header: the extra header parameters
    func httpHeaders(addingHeader header: [HTTPHeader?]? = nil) -> HTTPHeaders {
        var allHeaders = HTTPHeaders(defaultHeaders)
        guard let header = header else { return allHeaders }
        let acceptableHeaders = header.compactMap { $0 }
        acceptableHeaders.forEach {
            allHeaders.add($0)
        }
        return allHeaders
    }
}
