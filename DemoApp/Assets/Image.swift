//
//  Image.swift
//  TipQuick
//
//  Created by Narendra Kathayat on 8/11/20.
//  Copyright © 2020 Ebpearls. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Helper method to verify and get the image with given name
    /// - Parameter imageName: the name of image from asset
    /// - Returns: the image from given name
    private static func named(_ imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName) else {
            assertionFailure("The image associated with name \(imageName) was not found. Please check you have spelled it correctly.")
            return UIImage()
        }
        return image
    }
    
    /// The back button icon
    static var back: UIImage? { return UIImage.named("backArrow") }
    
    func setTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
