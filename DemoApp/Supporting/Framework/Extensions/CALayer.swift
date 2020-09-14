//
//  CALayer.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import UIKit

public extension CALayer {
    
    /// Method to apply shadow to any CALayer
    ///
    /// - Parameters:
    ///   - color: shadow color
    ///   - alpha: shadow alpha
    ///   - xPos: shadow x position
    ///   - yPos: shadow y position
    ///   - blur: shadow blur
    ///   - spread: shadow spread
    func applyShadow( color: UIColor = .black, alpha: Float = 0.5, xPos: CGFloat = 0, yPos: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPos, height: yPos)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let deltax = -spread
            let rect = bounds.insetBy(dx: deltax, dy: deltax)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
