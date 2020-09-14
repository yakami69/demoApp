//
//  File.swift
//  
//
//  Created by Narendra Bdr Kathayat on 1/29/20.
//

import Foundation

/// The user for facebook data
public struct FacebookUser {
    
    /// The access token from facebook login
    public var accessToken: String
    
    /// The user id from facebook
    public var facebookId: String
    
    /// The first name of the user
    public var firstName: String
    
    /// The last name of the user
    public var lastName: String
    
    /// The email for the user
    public var email: String?
    
    /// Convenience initializer
    public init(accessToken: String, facebookId: String, firstName: String, lastName: String, email: String?) {
        self.accessToken = accessToken
        self.facebookId = facebookId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
