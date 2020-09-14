//
//  Signature.swift
//  
//
//  Created by Narendra Bdr Kathayat on 2/20/20.
//

import UIKit

/// The signature object received after signing on signature view
public struct Signature {
    
    /// The signature image
    private(set) public var image : UIImage
    
    /// The date of signature
    private(set) public var date  : Date
    
    /// initializer
    init(signature: UIImage) {
        self.image = signature
        self.date = Date()
    }
}
