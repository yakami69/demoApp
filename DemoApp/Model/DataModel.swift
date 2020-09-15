//
//  DataModel.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/16/20.
//

import Foundation

struct Category: Codable {
    var objectId: String?
    var categoryName: String?
    var categoryImageURL: String?
    var subCategory: [SubCategory]?
    var business: [Business]?
}

struct SubCategory: Codable {
    var objectId: String?
    var subCategoryName: String?
    var subCategoryImageURL: String?
    var business: [Business]?
}

struct Business: Codable {
    var objectId: String?
    var businessName: String?
    var businessOwner: String?
    var businessEmail: String?
    var businessContact: String?
    var businessAddress: String?
    var businessImageURL: String?
    var businessDescription: String?
    var businessPrice: String?
}


