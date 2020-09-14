//
//  TextModelResult.swift
//  Framework
//
//  Created by Narendra Bdr Kathayat on 1/10/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import UIKit

/// The result of the interactor for the bounded textField
public struct TextModelResult {
    
    /// The textfield bounded to this model
    public var element: Any?
    
    /// The value in the textField
    public var value: String
    
    /// The error from interactor if present
    public var error: InteractorError?
    
    /// Public initailizer
    public init(element: Any?, value: String, error: InteractorError?) {
        self.element = element
        self.value = value
        self.error = error
    }
}
