//
//  CoreDataStack.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 1/6/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    
    /// Container For DB
    private var container: NSPersistentContainer!
    
    /// Main Context
    lazy var mainContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    /// Background Context (Parent)
    lazy var bgContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    /// Initialization of class
    static let shared = CoreDataStack()
    
    public init() {
        createPersistanceContainer()
    }
    
    /// Get description of SQLite file.
    func getStoreDescription() -> NSPersistentStoreDescription {
        
        /// Search Path for SQLite file
        let searchPathDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        /// Name of SQLite File with extension
        let modelFileWithExtension = "WeddingAppModel.sqlite"
        
        /// Locate the directory of 'searchPathDirectory', crates directory if not found, and returns the URL of directory
        let fileURL = try? FileManager.default.url(for: searchPathDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        /// URL of  SQLiteFile(DB)
        let url = fileURL?.appendingPathComponent(modelFileWithExtension)
        
        /// DB Description
        let description = NSPersistentStoreDescription()
        
        // DB Type
        description.type = NSSQLiteStoreType
        
        // URL of DB location
        description.url = url
        
        return description
    }
    
    /// LoadDB, if file doesnot exist, Creates one.
    func createPersistanceContainer() {
        // Name of CoreDataModel(filename.xcdatamodeld)
        container = NSPersistentContainer(name: "WeddingDataModel")
        
        // Gets DB information(DB type and DB URL)
        container.persistentStoreDescriptions = [getStoreDescription()]
        
        // Load DB, if file doesnot exists, creates an empty DB
        container.loadPersistentStores { (description, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("Successfully Loaded DB: \(String(describing: description.url))")
            }
        }
    }    
}
