//
//  HttpClient.swift
//
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Alamofire
import Combine

public class HttpClient: Client {
    
    /// The parser that will parse the response received from server response
    private let parser: Parser
    
    /// The subscription cleaner
    private var bag = Set<AnyCancellable>()
    
    /// Initializer
    ///
    /// - Parameter parser: the response parser
    public init(parser: Parser) {
        self.parser = parser
    }
    
    /// Method to request data from API using Alamofire
    ///
    /// - Parameters:
    ///   - router: the Almaofire router
    /// - Returns: observable of APIResponse
    public func performRequest<O>(type: O.Type, router: NetworkingRouter) -> AnyPublisher<NetworkingResult<O>, Never> {
        return Future<NetworkingResult<O>, Never> { [weak self] promise in
            AF.request(router).validate().responseJSON(completionHandler: { [weak self] (jsonResponse) in
                guard let self = self else { return }
                Logger.shared.log(jsonResponse)
                do {
                    promise(.success(try self.parser.parseResponse(type: O.self, jsonResponse, router: router)))
                } catch {
                    if let error = error as? NetworkingError {
                        promise(.success(NetworkingResult(success: false, error: error, router: router)))
                    } else {
                        promise(.success(NetworkingResult(success: false, error: .nonParsableErrorReceived, router: router)))
                    }
                }
            })
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
