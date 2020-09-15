//
//  AppEnvironment.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/11/20.
//

import Foundation
import Framework

/// The staging environment
struct Staging: Environment {
    var googleBaseURL: URL {
        guard let url = URL(string: "") else { fatalError("The staging environment url is not valid") }
        return url
    }
    
    var apiBaseURL: URL {
        guard let url = URL(string: "") else {
            fatalError("Please add the apis base url")
        }
        return url
    }
}

/// The Live environment
struct Live: Environment {
    var googleBaseURL: URL {
        guard let url = URL(string: "") else { fatalError("") }
        return url
    }
    
    var apiBaseURL: URL {
        guard let url = URL(string: "") else {
            fatalError("Please add the apis base url")
        }
        return url
    }
}

