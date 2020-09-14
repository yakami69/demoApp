//
//  AddressComponentKey.swift
//  
//
//  Created by mukesh on 7/22/20.
//

import Foundation

/// the keys we receive inside addressComponents.types from google API
enum AddressComponentKey: String {
    case city = "locality"
    case state = "administrative_area_level_1"
    case postalCode = "postal_code"
}
