//
//  MockClient.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Combine
import Alamofire

public class MockClient: Client {
    
    /// Flag to get valid data or not for testing purpose
    public var sendValidData = true
    
    /// The parser that will parse the response received from server response
    private let parser: ResponseParser
    
    /// Initializer
    ///
    /// - Parameter parser: the response parser
    public init(parser: ResponseParser) {
        self.parser = parser
    }
    
    public func performRequest<O>(type: O.Type, router: NetworkingRouter) -> AnyPublisher<NetworkingResult<O>, Never> {
        return Just(NetworkingResult(router: router)).eraseToAnyPublisher()
    }
}
