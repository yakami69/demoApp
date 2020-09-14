//
//  Pagination.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//
import Foundation

///Structure for the pagination dat afrom the api
public struct Pagination: Codable {
    
    /// The total number of data objects available
    public let total: Int
    
    /// The current page we are on
    public let page: Int
    
    /// Indicator that there is next page
    public var hasNextPage: Bool = false
    
    /// Initializer
    public init() {
        self.total = 0
        self.page = 0
        self.hasNextPage = true
    }
    
    /// The coding keys for the objects values
    enum CodingKeys: String, CodingKey {
        case total
        case page
    }
    
    /// Initializer for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total  = try container.decode(Int.self, forKey: .total)
        self.page   = try container.decode(Int.self, forKey: .page)
    }
    
    
    /// Method to update the hasNextPage flag based on fetchLimit
    /// - Parameter fetchLimit: the fetch limit
    mutating public func update(forLimit fetchLimit: Int) {
        let fetchObjects = page * fetchLimit
        let remainingObjects = total - fetchObjects
        hasNextPage = remainingObjects > 0
    }
}
