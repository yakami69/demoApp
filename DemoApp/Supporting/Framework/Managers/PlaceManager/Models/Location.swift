//
//  Location.swift
//  Place
//
//  Created by Narendra Kathayat on 3/15/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation

public struct Location: Codable {
    public var latitude: Double
    public var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
