//
//  NetworkingResult.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation

public struct NetworkingResult<R>: ResultMaker {
    public var success: Bool
    public var error: NetworkingError
    public var result: R?
    public var statusCode: Int
    public var pagination: Pagination?
    public var message: String
    public var title: String
    public var router: NetworkingRouter
    
    public init(success: Bool = true, error: NetworkingError = .none, result: R? = nil, statusCode: Int = 0, pagination: Pagination? = nil, title: String = "", message: String = "", router: NetworkingRouter) {
        self.success = success
        self.error = error
        self.result = result
        self.statusCode = statusCode
        self.pagination = pagination
        self.message = message
        self.title = title
        self.router = router
    }
}
