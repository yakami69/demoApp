//
//  AutoCompleteParser.swift
//  Place
//
//  Created by Narendra Kathayat on 3/14/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import Foundation
import Alamofire

public struct AutoCompleteParser: Parser {
    
    /// The result builder instance
    private let resultBuilder: ResultBuilder
    
    /// Initializer
    public init(resultBuilder: ResultBuilder) {
        self.resultBuilder = resultBuilder
    }
    
    /// Prepares the info object for us to build the object graph
    /// - Parameter data: the data received from response
    private func prepareInfo(_ data: Data) throws -> BuilderInfo {
        
        /// first check the top level object validity
        guard let serialized = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            throw NetworkingError.nonParsableErrorReceived
        }
        
        /// now extract the data object which is predefined for response
        if let responseValue = serialized[FrameworkConstant.ResponseKey.predictions.rawValue] as? [Any]{
            let requiredData = responseValue.count > 0 ? try JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted) : nil
            let info = BuilderInfo(title: "", message: "", isArray: true, data: requiredData, tokenInfo: nil, pagination: nil)
            return info
        } else if let responseValue = serialized[FrameworkConstant.ResponseKey.result.rawValue] as? [String: Any]{
            let requiredData = responseValue.count > 0 ? try JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted) : nil
            let info = BuilderInfo(title: "", message: "", isArray: true, data: requiredData, tokenInfo: nil, pagination: nil)
            return info
        } else if let responseValue = serialized[FrameworkConstant.ResponseKey.results.rawValue] as? [Any]{
            let requiredData = responseValue.count > 0 ? try JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted) : nil
            let info = BuilderInfo(title: "", message: "", isArray: true, data: requiredData, tokenInfo: nil, pagination: nil)
            return info
        } else {
            throw NetworkingError.nonParsableErrorReceived
        }
    }
    
    /// Method to parse the response from the response received through API
    ///
    /// - Parameters:
    ///   - response: the API response
    /// - Returns: API response
    /// - Throws: decoding or building errors
    public func parseResponse<O>(type: O.Type, _ response: AFDataResponse<Any>, router: NetworkingRouter) throws -> NetworkingResult<O> {
        
        //log
        Logger.shared.log(response)
        
        // decode the data info
        guard let data = response.data else { return NetworkingResult(success: false, error: .nonParsableErrorReceived, router: router) }
        let builderInfo = try prepareInfo(data)
        
        // prepare for error or result
        switch response.result {
        case .success:
            var apiResponse = NetworkingResult<O>(router: router)
            let statusCode = apiResponse.statusCode != 0 ? apiResponse.statusCode : response.response?.statusCode ?? 0
            if builderInfo.data != nil {
                apiResponse = try resultBuilder.buildWithInfo(type: O.self, builderInfo, router: router)
            }
            apiResponse.statusCode = statusCode
            return apiResponse
        case .failure(let error):
            let failedReason = builderInfo.message.isEmpty ? error.localizedDescription : builderInfo.message
            var result = NetworkingResult<O>(success: false, error: .failedReason(failedReason, response.response?.statusCode ?? 0), statusCode: response.response?.statusCode ?? 0, router: router)
            result.message = failedReason
            return result
        }
    }
}
