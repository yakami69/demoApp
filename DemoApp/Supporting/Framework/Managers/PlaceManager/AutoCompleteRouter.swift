//
//  AutoCompleteRouter.swift
//  Place
//
//  Created by Narendra Kathayat on 3/14/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation
import Alamofire

enum AutoCompleteRouter: NetworkingRouter {
    
    /// The path for the routes
    var path: String {
        switch self {
        case .address:
            return "place/details/json"
        case .place:
            return "place/autocomplete/json"
        case .geocode:
            return "geocode/json"
        }
    }
    
    /// No token validation
    var needTokenValidation: Bool { false }
    
    /// The http method to use
    var httpMethod: RequestMethod { .get }
    
    /// Indicate we need google API base url
    var isGoogleAPIRouter: Bool { true }
    
    /// The encoder to use
    var encoders: [RequestEncoder] {
        switch self {
        case .place(let parameters), .address(let parameters), .geocode(let parameters):
            return [.query(parameters)]
        }
    }
    
    /** To get the places **/
    case place(Parameters)
    
    /** To get the address details  ***/
    case address(Parameters)
    
    /** To get the geocode from address  ***/
    case geocode(Parameters)

}
