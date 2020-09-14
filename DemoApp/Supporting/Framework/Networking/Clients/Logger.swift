//
//  File.swift
//  
//
//  Created by Narendra Bdr Kathayat on 11/5/19.
//

import Alamofire
import Foundation

/// The class that we will use to log our outputs, so that in future we can inspect if anything goes boom
final public class Logger {
    
    // shared instancxe of our logger
    public static let shared = Logger()
    private init() {}
    
    /// Method to log the response of Alamofire request response cycle
    /// - Parameter response: the response received from alamofire request
    public func log(_ response: AFDataResponse<Any>) {
        //REQUEST OBJECT
        var requiredRawInfo = false
        let httpBodyData = response.request?.httpBody
        let httpHeaders = response.request?.allHTTPHeaderFields
        var requestObject = [String: Any]()
        var isValidJSON = true
        do {
            if let httpBody = httpBodyData {
                let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                requestObject["RequestData"] = json
            }
        } catch {
            isValidJSON = false
        }
        if !isValidJSON {
            requiredRawInfo = true
            if let httpBody = httpBodyData {
                if let stringData = String(data: httpBody, encoding: .utf8) {
                    requestObject["RequestData"] = stringData
                }
            }
        }
        if let headers = httpHeaders {
            requestObject["Headers"] = headers
        }
        if let httpMethod = response.request?.httpMethod {
            requestObject["Method"] = httpMethod
        }
        if let apiLink = response.request?.url?.absoluteString {
            requestObject["APILink"] = apiLink
        }
        //RESPONSE OBJECT
        var responseObject = [String: Any]()
        switch response.result {
        case .success(let data):
            responseObject["responseData"] = data
        case .failure(let error):
            requiredRawInfo = true
            responseObject["Error"] = error.localizedDescription
        }
        if let responseHeaders = response.response?.allHeaderFields {
            responseObject["Headers"] = responseHeaders
        }
        responseObject["StatusCode"] = response.response?.statusCode
        
        //Log all together
        var log = [String: Any]()
        log["HTTP_RESPONSE_OBJECT"] = responseObject
        log["HTTP_REQUEST_OBJECT"] = requestObject
        if let rawObject = response.data, let stringyfied = String(data: rawObject, encoding: .utf8), requiredRawInfo {
            log["RAW_DATA"] = stringyfied
        }
        //convert to data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: log, options: .prettyPrinted)
            print(String(data: jsonData, encoding: .utf8) ?? "Empty")
        } catch {
            print("Unable to convert log to data")
        }
    }
}
