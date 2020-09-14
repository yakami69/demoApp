//
//  Client.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Combine

public protocol Client {
    func performRequest<O>(type: O.Type, router: NetworkingRouter) -> AnyPublisher<NetworkingResult<O>, Never>
}
