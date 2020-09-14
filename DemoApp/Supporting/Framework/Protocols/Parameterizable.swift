//
//  Parameterizable.swift
//  FreshClinic
//
//  Created by Narendra Bdr Kathayat on 3/5/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import Foundation
import Alamofire

/// A protocol to encode the conforming codable object to its parametric values
public protocol Parameterizable where Self: Codable {
    func APIPrameters(requiredKeys: [String]) -> Parameters
}

/// Self implementation
extension Parameterizable {

    /// Method that will encode self to Parameter type and remove the empty result if applicable
    public func APIPrameters(requiredKeys: [String] = []) -> Parameters {
        do {

            /// try to encode the object
            let encodedData = try JSONEncoder().encode(self)

            /// check the encoding suceed by converting the data into Parameters
            guard let parameters = try JSONSerialization.jsonObject(with: encodedData, options: .mutableContainers) as? Parameters else {
                assertionFailure("Unable to convert data to object")
                return [:]
            }

            /// check the emptiness are remove if applicable
            let requiredParameters = parameters.filter {
                let value = $0.value
                if let list = value as? [Any] {
                    return !list.isEmpty
                } else if let text = value as? String {
                    if requiredKeys.contains($0.key) {
                        return true
                    }
                    return !text.isEmpty
                }
                return true
            }

            /// return the build parameters
            return requiredParameters

        } catch {
            assertionFailure("Something went wrong when encoding \(error.localizedDescription)")
            return [:]
        }
    }
}
