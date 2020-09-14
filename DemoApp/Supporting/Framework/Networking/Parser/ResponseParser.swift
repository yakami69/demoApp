//
//  ResponseParser.swift
//
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Combine
import Alamofire

public protocol Parser {
    init(resultBuilder: ResultBuilder)
    func parseResponse<O>(type: O.Type, _ response: AFDataResponse<Any>, router: NetworkingRouter) throws -> NetworkingResult<O>
}


/// The parser to parse the response
public struct ResponseParser: Parser {
    
    /// The result builder instance
    private let resultBuilder: ResultBuilder
    
    /// Initializer
    public init(resultBuilder: ResultBuilder) {
        self.resultBuilder = resultBuilder
    }
    
    /// Prepares the info object for us to build the object graph
    /// - Parameter data: the data received from response
    /// - Parameter statucCode: the status code from response
    private func prepareInfo(_ data: Data, statusCode: Int) throws -> BuilderInfo {
        
        /// first check the top level object validity
        guard let serialized = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            throw NetworkingError.nonParsableErrorReceived
        }
        
        /// extract the message
        let message = serialized[FrameworkConstant.ResponseKey.message.rawValue] as? String ?? ""
        
        /// extract the title
        let title = serialized[FrameworkConstant.ResponseKey.title.rawValue] as? String ?? ""
        
        /// now extract the data object which is predefined for response
        if let responseValue = serialized[FrameworkConstant.ResponseKey.data.rawValue] as? [String: Any] {
            // now we check if this is single object or not
            if let docs = responseValue[FrameworkConstant.ResponseKey.docs.rawValue] as? [[String: Any]] {
                // list of objects
                let requiredData = try JSONSerialization.data(withJSONObject: docs, options: .prettyPrinted)
                if let paginationObject = responseValue[FrameworkConstant.ResponseKey.pagination.rawValue] as? [String: Any] {
                    let pageData = try JSONSerialization.data(withJSONObject: paginationObject, options: .prettyPrinted)
                    let pagination = try JSONDecoder().decode(Pagination.self, from: pageData)
                    let info = BuilderInfo(title: title, message: message, isArray: true, data: requiredData, tokenInfo: nil, pagination: pagination)
                    return info
                } else {
                    let info = BuilderInfo(title: title, message: message, isArray: true, data: requiredData, tokenInfo: nil, pagination: nil)
                    return info
                }
                
            } else {
                // single object
                let requiredData = try JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted)
                let info = BuilderInfo(title: title, message: message, isArray: false, data: requiredData, tokenInfo: nil, pagination: nil)
                return info
            }
        } else if let responseValue = serialized[FrameworkConstant.ResponseKey.data.rawValue] as? [Any]{
            let requiredData = responseValue.count > 0 ? try JSONSerialization.data(withJSONObject: responseValue, options: .prettyPrinted) : nil
            let info = BuilderInfo(title: title, message: message, isArray: true, data: requiredData, tokenInfo: nil, pagination: nil)
            return info
        } else {
            if statusCode == 200 {
                return BuilderInfo(title: title, message: message, isArray: false, data: nil, tokenInfo: nil, pagination: nil)
            } else {
                throw NetworkingError.custom(message)
            }
        }
    }
    
    /// Our Auth token data is received through response headers, so we have to parse those objects from header fields
    ///
    /// - Parameter response: the response received
    /// - Returns: generated token data
    private func extractTokenInfoFromResponseIfPresent(_ response: AFDataResponse<Any>) -> Any? {
        guard let allHTTPHeaders = response.response?.allHeaderFields else { return nil }
        
        //we are looking for three keys for token, all three must be present for valid refresh
        guard let accessToken = allHTTPHeaders[Token.CodingKeys.accessToken.rawValue],
            let refreshToken = allHTTPHeaders[Token.CodingKeys.refreshToken.rawValue],
            let expiresIn = allHTTPHeaders[Token.CodingKeys.refreshExpiresIn.rawValue],
            let accessExpiresIn = allHTTPHeaders[Token.CodingKeys.accessExpiresIn.rawValue] else { return nil }
        
        //now we build the parseable JSON object
        let tokenJSON: [String: Any] = [Token.CodingKeys.accessToken.rawValue: accessToken,
                                        Token.CodingKeys.refreshToken.rawValue: refreshToken,
                                        Token.CodingKeys.refreshExpiresIn.rawValue: expiresIn,
                                        Token.CodingKeys.objectId.rawValue: "AuthToken",
                                        Token.CodingKeys.accessExpiresIn.rawValue: accessExpiresIn]
        
        return tokenJSON
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
        
        // prepare for error or result
        switch response.result {
        case .success:
            
            // decode the data info
            guard let data = response.data else {
                return NetworkingResult(success: false, error: .nonParsableErrorReceived, router: router)
            }
            var builderInfo = try prepareInfo(data, statusCode: response.response?.statusCode ?? 0)
            
            var apiResponse = NetworkingResult<O>(router: router)
            let statusCode = apiResponse.statusCode != 0 ? apiResponse.statusCode : response.response?.statusCode ?? 0
            let tokenData = extractTokenInfoFromResponseIfPresent(response)
            builderInfo.tokenInfo = tokenData
            if builderInfo.data != nil {
                apiResponse = try resultBuilder.buildWithInfo(type: O.self, builderInfo, router: router)
            } else {
                apiResponse.title = builderInfo.title
                apiResponse.message = builderInfo.message
            }
            apiResponse.statusCode = statusCode
            return apiResponse
        case .failure(let error):
            
            // decode the data info
            guard let data = response.data else {
                
                // checking for request timed out
                if response.response?.statusCode == NSURLErrorTimedOut {
                    return NetworkingResult(success: false, error: .requestTimedOut, router: router)
                }
                return NetworkingResult(success: false, error: .nonParsableErrorReceived, router: router)
            }
            
            if response.response?.statusCode == NetworkingError.badGateway.code {
                return NetworkingResult(success: false, error: .badGateway, router: router)
            }
            
            if response.response?.statusCode == NetworkingError.gatewayTimeout.code {
                return NetworkingResult(success: false, error: .gatewayTimeout, router: router)
            }
            
            let builderInfo = try prepareInfo(data, statusCode: response.response?.statusCode ?? 0)
            let failedReason = builderInfo.message.isEmpty ? error.localizedDescription : builderInfo.message
            var result = NetworkingResult<O>(success: false, error: .failedReason(failedReason, response.response?.statusCode ?? 0), statusCode: response.response?.statusCode ?? 0, router: router)
            result.message = failedReason
            return result
        }
    }
}
