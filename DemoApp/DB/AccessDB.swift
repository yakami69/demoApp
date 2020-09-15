////
////  AccessDB.swift
////  Wedding App
////
////  Created by Mahesh Yakami on 1/7/20.
////
//
//import Foundation
//import CoreData
//
//
//class AccessDB: NSObject, NSFetchedResultsControllerDelegate{
//    
//    
//    /// Main context (child context)
//    var mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext
//    
//    /// Background Context (Parent context)
//    var backGroundContext: NSManagedObjectContext = CoreDataStack.shared.bgContext
//    
//    lazy var fetchBusinessController: NSFetchedResultsController<Business> = {
//        let request = NSFetchRequest<Business>(entityName: "Business")
//        request.sortDescriptors = []
//        let fetchController = NSFetchedResultsController<Business>(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchController
//    }()
//    
//    lazy var fetchCategoryController: NSFetchedResultsController<Category> = {
//        let request = NSFetchRequest<Category>(entityName: "Category")
//        request.sortDescriptors = []
//        let fetchController = NSFetchedResultsController<Category>(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchController
//    }()
//    
//    
//    override init() {
//        super.init()
//        try? fetchCategoryController.performFetch()
//        try? fetchBusinessController.performFetch()
//    }
//    
//    /// Fetch category form DB
//    /// - Parameter fetchOffset: fetch offset
//    func fetchCategory(fetchOffset: Int, fetchLimit : Int = 15) -> [Category]{
//        
//        let request = NSFetchRequest<Category>(entityName: "Category")
//        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
//        request.fetchLimit = fetchLimit
//        request.fetchOffset = fetchOffset
//        do{
//            let results = try mainContext.fetch(request)
//            return results
//        }catch {
//            debugPrint("fetch Category Error: \(error)")
//        }
//        return []
//    }
//    
//    /// Fetch subcategory form DB
//    /// - Parameter fetchOffset: fetch offset
//    func fetchSubCategory(fetchOffset: Int, fetchLimit : Int = 15) -> [SubCategory]{
//        
//        let request = NSFetchRequest<SubCategory>(entityName: "SubCategory")
//        request.sortDescriptors = [NSSortDescriptor(key: "subCategoryName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
//        request.fetchLimit = fetchLimit
//        request.fetchOffset = fetchOffset
//        do{
//            let results = try mainContext.fetch(request)
//            return results
//        }catch {
//            debugPrint("fetch SubCategory Error: \(error)")
//        }
//        return []
//    }
//    
//    /// Function to fetch Businesses from DB
//    /// - Parameter fetchOffset: how many records to skip before fetching
//    func fetchBusiness(fetchOffset: Int, fetchLimit: Int) -> [Business]{
//        let request = NSFetchRequest<Business>(entityName: "Business")
//        request.sortDescriptors = [NSSortDescriptor(key: "businessName", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
//        request.fetchOffset = fetchOffset
//        request.fetchLimit = fetchLimit
//        do{
//            let results = try mainContext.fetch(request)
//            return results
//        }
//        catch {
//            debugPrint("fetch Business Error: \(error)")
//        }
//        return []
//    }
//    
//    /// Function for Searching business.
//    /// -if category is not provided then search all categories
//    /// -if category is provided but search parameter not provided then returns all business of that category
//    /// -if both parameters are provided then returns business that matches business name or description in that particular category
//    /// - Parameters:
//    ///   - searchParameter: search parameter/ textinput for search
//    ///   - withCategory: search in specified Category
//    func searchBusiness(searchParameter: String, withCategory: Category?) -> [Business]{
//        let request = NSFetchRequest<Business>(entityName: "Businesses")
//        request.sortDescriptors = [NSSortDescriptor(key: "businessName", ascending: true)]
//        //request.fetchLimit = 10
//        if withCategory == nil {
//            //Business name contains searchparameter(case insensetive)
//            request.predicate = NSPredicate(format: "(businessName CONTAINS[c] %@) OR (businessDescription CONTAINS[c] %@)", argumentArray: [searchParameter, searchParameter])
//            
//        } else if searchParameter == "" {
//            //fetch all business with given category
//            request.predicate = NSPredicate(format: "businessCategory.objectId == %@", withCategory!.objectId!)
//        }
//        else {
//            //Business name containing searchParameter(case insensetive) and matches categoryname
//            request.predicate = NSPredicate(format: "(businessCategory.objectId == %@) AND ((businessName CONTAINS[c] %@) OR (businessDescription CONTAINS[c] %@))", argumentArray: [withCategory!.objectId, searchParameter, searchParameter])
//        }
//        do{
//            let results = try mainContext.fetch(request)
//            return results
//        }catch {
//            debugPrint("search Business Error: \(error)")
//
//        }
//        return []
//    }
//    
//    /// search category according to search parameter
//    /// -returns category array that matches its name with search parameter
//    /// - Parameter searchParameter: search parameter/ text input
//    func searchCategory(searchParameter: String) -> [Category]{
//        
//        let request = NSFetchRequest<Category>(entityName: "Category")
//        request.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
//        request.predicate = NSPredicate(format: "categoryName CONTAINS[c] %@", searchParameter)
//        do{
//            let results = try mainContext.fetch(request)
//            return results
//        }catch {
//            debugPrint("search Category Error: \(error)")
//
//        }
//        return []
//    }
//    
//    /// Fetches Businesses object with particular 'objectId'
//    /// - Parameter withId: objectId of Businesses
//    func getBusiness(withId: String) -> Business?{
//        let request = NSFetchRequest<Business>(entityName: "Business")
//        request.sortDescriptors = []
//        request.predicate = NSPredicate(format: "objectId == %@", withId)
//        let results = try? backGroundContext.fetch(request)
//        return results?.first
//    }
//    
//    /// Fetches Category object with particular 'objectId'
//    /// - Parameter withId: objectId of Category
//    func getCategory(withId: String) -> Category?{
//        let request = NSFetchRequest<Category>(entityName: "Category")
//        request.sortDescriptors = []
//        request.predicate = NSPredicate(format: "objectId == %@", withId)
//        let results = try? backGroundContext.fetch(request)
//        return results?.first
//    }
//    
//    /// Fetches Category object with particular 'objectId'
//    /// - Parameter withId: objectId of Category
//    func getSubCategory(withId: String) -> SubCategory?{
//        let request = NSFetchRequest<SubCategory>(entityName: "SubCategory")
//        request.sortDescriptors = []
//        request.predicate = NSPredicate(format: "objectId == %@", withId)
//        let results = try? backGroundContext.fetch(request)
//        return results?.first
//    }
//    
//}
//
//extension AccessDB {
//    
//    /// Adding JSON to CoreData
//    func loadJSONToDB() {
//        
//        /// Load local JSON file and its contents
//        guard let jSONURL = Bundle.main.url(forResource: "MOCK_DATA", withExtension: ".json"),
//            let jSONData = try? Data(contentsOf: jSONURL) else {
//                debugPrint("File Not Found / File Not Loaded")
//                return
//        }
//        
//        /// Decoding JSON file Contents
//        guard let decodedJSONData = try? JSONDecoder().decode([JSONCategory].self, from: jSONData) else {
//            debugPrint("Decode Failure")
//            return}
//        
//        /// Adding JSON Decoded Contents to CoreData
//        for data in decodedJSONData {
//            addCategory(objectId: data.objectId,
//                        categoryName: data.categoryName,
//                        categoryImageUrl: data.categoryImageURL)
//            
//        }
//        
//        // Saving changes to CoreData
//        do {
//            try backGroundContext.save()
//        } catch {
//            debugPrint("Error saving category-- \(error.localizedDescription)")
//        }
//        
//        for data in decodedJSONData {
//            if data.business?.count != 0 {
//                for business in data.business! {
//                    guard let category = getCategory(withId: data.objectId) else {
//                        debugPrint("failed to fetch category while adding to business")
//                        return
//                    }
//                    addBusiness(objectId: business.objectId!,
//                                businessName: business.businessName!,
//                                businessEmail: business.businessEmail!,
//                                businessContact: (business.businessContact).toInt64(),
//                                businessAddress: business.businessAddress!,
//                                businessImageURL: business.businessImageURL!,
//                                businessDescription: business.businessDescription!,
//                                businessOwner: business.businessOwner!,
//                                businessCategory: category)
//                }
//            }
//        }
//        
//        // Saving changes to CoreData
//        do {
//            try backGroundContext.save()
//        } catch {
//            debugPrint("Error saving business -- \(error.localizedDescription)")
//        }
//        
//    }
//    
//    /// Method to add Category in CoreData DB
//    /// - Parameters:
//    ///   - objectId: objectId of Category
//    ///   - categoryName: categoryName
//    ///   - categoryImageUrl: categoryImageUrl
//    func addCategory(objectId: String, categoryName: String, categoryImageUrl: String){
//        let category = Category(context: backGroundContext)
//        category.objectId = objectId
//        category.categoryName = categoryName
//        category.categoryImageURL = categoryImageUrl
//    }
//    
//    
//    /// Method to add Businesses in CoreData DB
//    /// - Parameters:
//    ///   - objectId: objectId
//    ///   - businessName: businessName
//    ///   - businessEmail: businessEmail
//    ///   - businessContact: businessContact
//    ///   - businessAddress: businessAddress
//    ///   - businessImageURL: businessImageURL
//    ///   - businessDescription: businessDescription
//    func addBusiness(objectId: String, businessName: String, businessEmail: String, businessContact: Int64, businessAddress: String, businessImageURL: String, businessDescription: String, businessOwner: String, businessCategory: Category? = nil) {
//        let business = Business(context: backGroundContext)
//        business.objectId = objectId
//        business.businessName = businessName
//        business.businessEmail = businessEmail
//        business.businessContact = businessContact
//        business.businessAddress = businessAddress
//        business.businessImageURL = businessImageURL
//        business.businessDescription = businessDescription
//        business.businessCategory = businessCategory
//        business.businessOwner = businessOwner
//    }
//    
//    func saveDataToDataBase(){
//        // Saving changes to CoreData
//        do {
//            try backGroundContext.save()
//        } catch {
//            debugPrint("Error saving -- \(error.localizedDescription)")
//        }
//    }
//}
//
///// Category Structure as of DB
//struct JsonCategoryStructure: Codable {
//    var objectId: String
//    var categoryName: String
//    var categoryImageURL: String
//    var businesses: [JsonBusinessesStructure]?
//}
//
///// Businesses Structure as of DB
//struct JsonBusinessesStructure: Codable {
//    var objectId: String
//    var businessName: String
//    var businessEmail: String
//    var businessContact: String
//    var businessAddress: String
//    var businessImageURL: String
//    var businessDescription: String
//    var businessOwner : String
//}
//
//
