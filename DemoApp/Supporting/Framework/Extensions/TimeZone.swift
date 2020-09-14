//
//  File.swift
//  
//
//  Created by mukesh on 6/22/20.
//

import Foundation

public extension TimeZone {
    
    /// UTC Time zone
    static var UTCTimeZone: TimeZone? = { return TimeZone(abbreviation: "UTC") }()
}
