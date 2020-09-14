//
//  Routable.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Foundation
import Alamofire

/// The encoder to use for the request
public enum RequestEncoder {
    case none
    case json(Parameters?)
    case url(Parameters?)
    case query(Parameters?)
}

public enum RequestMethod {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
}

public protocol NetworkingRouter: URLRequestConvertible {
    
    /// The headers required for every requests
    var headers: HTTPHeaders { get }
    
    /// Need tokenValidation: flag to indicate that when request is perform the token validity is test first
    var needTokenValidation: Bool { get }
    
    /// The path of the endpoint
    var path: String { get }
    
    /// The httpMethod for endpoint
    var httpMethod: RequestMethod { get }
    
    /// The encoder to be used for the request encoding
    var encoders: [RequestEncoder] { get }

    /// is google api router
    var isGoogleAPIRouter: Bool { get }
    
    /// The request 
    func getRequest() throws -> URLRequest
}

public extension NetworkingRouter {
    
    /// Authorization header is put through here to each router
    var headers: HTTPHeaders {
        if needTokenValidation {
            guard let authHeader = TokenManagerFactory.get().authHeader else {
                assertionFailure("\(Self.self) api requested to validate token, which cannot be found in the system")
                return Config.default.httpHeaders()
            }
            return Config.default.httpHeaders(addingHeader: [authHeader])
        }
        return Config.default.httpHeaders()
    }
    
    /// indicator to indicate that a router will attempt to add token to header when requesting service
    var needTokenValidation: Bool { return true }

    /// set isGoogleAPIRouter to false by default
    var isGoogleAPIRouter: Bool { return false }
    
    /// Create the urlRequest
    func getRequest() throws -> URLRequest  {

        /// the base url
        let baseURL = isGoogleAPIRouter ? Config.default.googleAPIURL : Config.default.serverURL

        /// create request
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.name) }
        
        /// set request method
        switch httpMethod {
        case .connect:
            urlRequest.httpMethod = HTTPMethod.connect.rawValue
        case .delete:
            urlRequest.httpMethod = HTTPMethod.delete.rawValue
        case .get:
            urlRequest.httpMethod = HTTPMethod.get.rawValue
        case .head:
            urlRequest.httpMethod = HTTPMethod.head.rawValue
        case .options:
            urlRequest.httpMethod = HTTPMethod.options.rawValue
        case .patch:
            urlRequest.httpMethod = HTTPMethod.patch.rawValue
        case .post:
            urlRequest.httpMethod = HTTPMethod.post.rawValue
        case .put:
            urlRequest.httpMethod = HTTPMethod.put.rawValue
        case .trace:
            urlRequest.httpMethod = HTTPMethod.trace.rawValue
        }
        
        /// Set encoder
        try encoders.forEach { routeEncoder in
            switch routeEncoder {
            case .json(let parameters):
                urlRequest =  try JSONEncoding.default.encode(urlRequest, with: parameters)
            case .query(let parameters):
                urlRequest =  try URLEncoding.queryString.encode(urlRequest, with: parameters)
            case .url(let parameters):
                urlRequest =  try URLEncoding.default.encode(urlRequest, with: parameters)
            case .none:
                break
            }
        }
        
        /// return request
        return urlRequest
    }
    
    /// The base protocol implementation
    func asURLRequest() throws -> URLRequest {
        return try getRequest()
    }
}

/// The none router, that will be used for the none case
public enum EraserRouter: NetworkingRouter {
    case none
    
    public var path: String { return "" }
    public var httpMethod: RequestMethod { return .get }
    public var encoders: [RequestEncoder] { return [.none] }
}
