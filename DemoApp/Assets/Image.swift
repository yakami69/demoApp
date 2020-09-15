//
//  Image.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/11/20.
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
    
    static var backgroundImage: UIImage? { return UIImage.named("backgroundImage") }
    
    func setTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
