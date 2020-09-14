//
//  FrameworkOperation.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Combine

/// Class that will used for queueing
public final class FrameworkOperation: Operation {
    
    /// The bag to dispose the subcriptions
    private var bag = Set<AnyCancellable>()
    
    /// The queueable
    private let queueable: OperationQueueable
    
    /// The identifier for this operation
    public let operationIdentifier: String
    
    /// Trigger for the synchronizer state
    let trigger = PassthroughSubject<SynchronizerState, Never>()
    
    /// Initializer
    public init(queueable: OperationQueueable) {
        self.queueable = queueable
        self.operationIdentifier = UUID().uuidString
    }
    
    /// Trigger for when the states are changed
    var operationState: OperationState = .ready {
        didSet {
            self.didChangeValue(forKey: oldValue.queueKeyPath)
            self.didChangeValue(forKey: operationState.queueKeyPath)
        } willSet {
            self.willChangeValue(forKey: operationState.queueKeyPath)
            self.willChangeValue(forKey: newValue.queueKeyPath)
        }
    }
    
    /// The main operation method
    override public func start() {
        
        //check if opertaion is cancelled, if cancelled then return else continue
        guard !isCancelled else { self.operationState = .finished; return }
        
        //start the sync
        self.operationState = .executing
    
        //observe sync to complete
        queueable.trigger.sink { [weak self] state in
            guard let self = self else { return }
            self.handleTriggerState(state)
            self.trigger.send(state)
        }.store(in: &bag)
        
        //start the request
        queueable.start()
    }
    
    private func handleTriggerState(_ state: SynchronizerState) {
        switch state {
        case .completed:
            self.operationState = .finished
        default: break
        }
    }
    
    /// Operation inherited
    override public var isFinished: Bool { return operationState == .finished }
    override public var isExecuting: Bool { return operationState == .executing }
    override public var isReady: Bool { return operationState == .ready }
    override public var isAsynchronous: Bool { return true }
}


/// The pending operation queue
public class PendingOperations {
    
    /// Flag to indicate if multiple operation can be concurrent
    private let concurrent: Bool
    
    /// Initializer
    public init(concurrent: Bool) {
        self.concurrent = concurrent
    }
    
    /// The operations that are queued
    public lazy var inProgressOperation = [String: Operation]()
    
    /// The opration queue
    public lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "FrameworkOperationQueue"
        queue.maxConcurrentOperationCount = self.concurrent ? OperationQueue.defaultMaxConcurrentOperationCount : 1
        return queue
    }()
}
