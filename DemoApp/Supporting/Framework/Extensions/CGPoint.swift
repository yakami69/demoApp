//
//  CGPoint.swift
//  
//
//  Created by Narendra Bdr Kathayat on 2/24/20.
//

import UIKit

extension CGPoint {
    
    /// Method to get the midpoint between two Points
    /// - Parameter point: the other point
    func midPoint(fromPoint point: CGPoint) -> CGPoint {
        CGPoint(x: (x + point.x) * 0.5, y: (y + point.y) * 0.5);
    }
    
}
