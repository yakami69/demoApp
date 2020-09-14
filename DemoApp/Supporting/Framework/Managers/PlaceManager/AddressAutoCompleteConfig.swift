//
//  AddressAutoCompleteConfig.swift
//  Place
//
//  Created by Narendra Kathayat on 3/15/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation

public class AddressAutoCompleteConfig {
    
    /// The google place API KEY
    let apiKey: String
    
    /// The Unique session token
    let sessionToken: String
    
    /// The language of the search
    let language: String
    
    /// The country ISO of the search
    let country: String
    
    /// Initializer
    public init(apiKey: String, language: String = "en", country: String = "AU", sessionToken: String = UUID().uuidString) {
        self.apiKey = apiKey
        self.language = language
        self.country = country
        self.sessionToken = sessionToken
    }
}
