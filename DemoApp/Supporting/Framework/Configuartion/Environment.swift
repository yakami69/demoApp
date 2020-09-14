//
//  File.swift
//  
//
//  Created by Narendra Bdr Kathayat on 1/30/20.
//

import Foundation

public protocol Environment {
    
    /// The base URL for api
    var apiBaseURL: URL { get }

    /// The base URL for google
    var googleBaseURL: URL { get }
}

extension Environment {
    var googleBaseURL: URL {
        fatalError("Please provide the URL from environment, before using")
    }
}
