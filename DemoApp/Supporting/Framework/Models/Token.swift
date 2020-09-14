//
//  Token.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation

/// The data transfer object for Token model
public struct Token: Codable {
    public var objectId: String
    public var accessToken: String
    public var refreshToken: String
    public var refreshExpiresIn: String
    public var accessExpiresIn: String
    public var refreshedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case objectId = "_id"
        case accessToken
        case refreshToken
        case refreshExpiresIn = "refreshTokenExpiresIn"
        case refreshedDate
        case accessExpiresIn = "accessTokenExpiresIn"
    }
    
    //making compiler happy
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(refreshExpiresIn, forKey: .refreshExpiresIn)
        try container.encode(refreshedDate, forKey: .refreshedDate)
        try container.encode(accessExpiresIn, forKey: .accessExpiresIn)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId       = try container.decodeIfPresent(String.self, forKey: .objectId) ?? "Bearer"
        self.accessToken    = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken   = try container.decode(String.self, forKey: .refreshToken)
        self.refreshExpiresIn      = try container.decode(String.self, forKey: .refreshExpiresIn)
        self.accessExpiresIn  = try container.decode(String.self, forKey: .accessExpiresIn)
        self.refreshedDate  = Date()
    }
}
