//
//  Decodable.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import Foundation

public extension Decodable {
    init(data: Data) throws {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            if let decodingError = error as? DecodingError {
                print(decodingError)
            } else {
                print(error.localizedDescription)
            }
            throw error
        }
    }
}
