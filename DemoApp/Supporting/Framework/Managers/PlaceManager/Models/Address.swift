//
//  Address.swift
//  Place
//
//  Created by Narendra Kathayat on 3/14/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation

public struct Address: Codable {
    
    public var address: String
    public var geometry: Geometry
    public var placeName: String
    public var addressComponents: [AddressComponent]
    public var postalCode: String {
        searchInsideAddressComponent(forKey: AddressComponentKey.postalCode.rawValue)
    }
    public var city: String {
        searchInsideAddressComponent(forKey: AddressComponentKey.city.rawValue)
    }
    public var state: String {
        searchInsideAddressComponent(forKey: AddressComponentKey.state.rawValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case geometry
        case placeName = "name"
        case addressComponents = "address_components"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        geometry = try container.decode(Geometry.self, forKey: .geometry)
        placeName = try container.decodeIfPresent(String.self, forKey: .placeName) ?? ""
        addressComponents = try container.decodeIfPresent([AddressComponent].self, forKey: .addressComponents) ?? []
    }
    
    public func encode(to encoder: Encoder) throws { }
    
    public func searchInsideAddressComponent(forKey key: String) -> String {
        for addressComponent in addressComponents {
            for type in addressComponent.types where type == key {
                return addressComponent.longName
            }
        }
        return ""
    }
}
