//
//  Place.swift
//  Place
//
//  Created by Narendra Kathayat on 3/15/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation

struct Place: Codable {
    var placeId: String
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
    }
}
