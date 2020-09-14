//
//  Networking.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

import Foundation
import Combine

/// The networking class to manage the operation queue and publish the received response
final public class Networking {
    
    /// Initializer
    public init( configuration: NetworkingConfiguration) {
        self.configuration = configuration
    }
    
    /// The configured data instance
    private let configuration: NetworkingConfiguration
    
    /// Thread sanitizer lock
    private let lock = NSLock()
    
    /// The disposing bag
    private var bag = Set<AnyCancellable>()
    
    /// The operations that are queued
    private var pending = PendingOperations(concurrent: true)
    
    /// The operations count currently queued
    lazy var operationCount: Int = { pending.inProgressOperation.count }()
    
    /// Method that will start the request, this method create a queueable object and then add to operation queue for processing
    /// - Parameter router: the router of the request
    /// - Parameter client: the client that will handle the request
    public func requestObject<O>(type: O.Type, router: NetworkingRouter, completion: @escaping (_ result: NetworkingResult<O>) -> Void) {
        //create the operation 
        let queueable = RequestSynchronizer<O>(client: configuration.client, router: router, tokenManager: configuration.tokenManager)
        addToOperation(type: O.self, queueable, completion: completion)
    }
    
    /// This method will add the operation to queue and cleanup when completed
    ///
    /// - Parameter queueable: the queueable to add as operation
    func addToOperation<O>(type: O.Type, _ queueable: OperationQueueable, completion: @escaping (_ result: NetworkingResult<O>) -> Void) {
        
        // Create the operation
        let operation = FrameworkOperation(queueable: queueable)
        
        //check the completion state
        operation.completionBlock = { [weak self] in
            guard let `self` = self, !operation.isCancelled else { return }
            self.pending.inProgressOperation.removeValue(forKey: operation.operationIdentifier)
        }
        
        // lock for read/write
        lock.lock()
        
        //add to queue
        pending.inProgressOperation[operation.operationIdentifier] = operation
        pending.operationQueue.addOperation(operation)
        
        // unlock the read/write
        lock.unlock()
        
        // listen for the operation events
        operation.trigger.sink { [weak self](state) in
            guard let `self` = self else { return }
            self.handleSyncronizerState(type: O.self, state, completion: completion)
        }.store(in: &bag)
    }
    
    /// Method to handle the state change of the synchronizer operation
    ///
    /// - Parameter state: the sync state
    private func handleSyncronizerState<O>(type: O.Type, _ state: SynchronizerState, completion: (_ result: NetworkingResult<O>) -> Void) {
        switch state {
        case .completed(let result):
            guard let networkingResult = result as? NetworkingResult<O> else {
                assertionFailure("The result is not of the networking result type")
                return
            }
            completion(networkingResult)
        case .suspendQueue:
            pending.operationQueue.isSuspended = true
        case .resumeQueue:
            pending.operationQueue.isSuspended = false
        case .terminate:
            pending.operationQueue.isSuspended = true
            pending.operationQueue.cancelAllOperations()
            pending.inProgressOperation.removeAll()
            pending.operationQueue.isSuspended = false
        default:
            debugPrint("Invalid synchronizer state received for network request -> \(#file), \(#line)")
            assertionFailure()
        }
    }
}
