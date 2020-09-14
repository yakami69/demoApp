//
//  UIView.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import UIKit

public extension UIView {
    
    /// The name of the view
    static var identifier: String {
        return String(describing: self)
    }
    
    /// Method that will take the snapshot of the view
    func snap() -> UIImage? {
        
        // clear the context
        defer {
             UIGraphicsEndImageContext()
        }
        
        // set the context for drawing
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // draw in the context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // get the drawn image from context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
       // return the image
        return image
    }
}
