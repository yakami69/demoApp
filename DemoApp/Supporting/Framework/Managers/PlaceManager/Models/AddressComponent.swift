//
//  AddressComponent.swift
//  
//
//  Created by mukesh on 7/22/20.
//

import Foundation

public struct AddressComponent: Codable {
    public var shortName: String
    public var longName: String
    public var types: [String]
    
    enum CodingKeys: String, CodingKey {
        case shortName = "short_name"
        case longName = "long_name"
        case types
    }
}
