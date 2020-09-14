//
//  OperationQueueable.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Combine

/// The operation queueable protocol for Operation
public protocol OperationQueueable {
    func start()
    var trigger: PassthroughSubject<SynchronizerState, Never> { get set }
}
