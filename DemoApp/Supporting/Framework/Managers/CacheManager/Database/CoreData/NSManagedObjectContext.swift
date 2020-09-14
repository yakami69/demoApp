//
//  NSManagedObjectContext.swift
//  DBCheck
//
//  Created by Narendra Kathayat on 4/27/20.
//  Copyright © 2020 Narendra Kathayat. All rights reserved.
//

import CoreData

// MARK: - Managed object context save implementation
extension NSManagedObjectContext {
    
    /// Saves a context
    /// - Parameter completion: the completion after save
    public func save(completion: SaveResult?) {
        
        // check if we have changes
        guard self.hasChanges else { completion?(true, .none); return }
        
        // the result
        var result = true
        
        // try to save
        do {
            try self.save()
        } catch {
            result = false
            self.rollback()
        }
        
        // check if parent needs saving
        if let parentContext = self.parent, result != false {
            parentContext.perform {
                self.save { (success, error)  in
                    if !success {
                        self.rollback()
                    }
                    completion?(success, error)
                }
            }
        } else {
            completion?(result, .none)
        }
    }
}

