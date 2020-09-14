//
//  FetchResultController.swift
//  
//
//  Created by Narendra Kathayat on 3/18/20.
//

import Foundation
import CoreData

final public class FetchResultController<T: NSManagedObject> {
    
    /// The data base that will be used by FetchController
    private let database: Database
    private let sectionKeyPath: String?
    
    /// Init with type
    public init(type: DatabaseType, sectionKeyPath: String? = nil) {
        self.sectionKeyPath = sectionKeyPath
        switch type {
        case .coreData:
            database = CoreDataDatabase.shared
        }
    }
    
    /// Methof to get the fetch resultcontroller
    /// - Parameter fetchRequest: the fetch request
    public func get(fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        
        guard let context = database.context else {
            fatalError("Context cannot be constructed")
        }
        
        let fetchResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionKeyPath, cacheName: nil)
        
        return fetchResultsController
    }

}
