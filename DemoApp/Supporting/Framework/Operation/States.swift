//
//  States.swift
//  
//
//  Created by Narendra Bdr Kathayat on 10/24/19.
//

/// The state of the operations that we will perform
///
/// - ready: The initial ready state
/// - executing: The executing state
/// - finished: the Completed state
enum OperationState: Int {
    case ready
    case executing
    case finished
    
    var queueKeyPath: String {
        switch self {
        case .ready: return "isReady"
        case .executing: return "isExecuting"
        case .finished: return "isFinished"
        }
    }
}

/// The states protocol
public protocol ResultMaker { }

/// The state of the operation queueable
///
/// - progress: the synschronizer is sending progress
/// - userDataModified: the state to indicate current user data has been modified
/// - finished: the synchronizer has finished its work
public enum SynchronizerState {
    
    /// Operation queue state
    case suspendQueue
    case resumeQueue
    case terminate
    case completed(ResultMaker)
    case pending(ResultMaker)
}
