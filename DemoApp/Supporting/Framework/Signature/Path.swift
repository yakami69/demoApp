//
//  File.swift
//  
//
//  Created by Narendra Bdr Kathayat on 2/20/20.
//

import UIKit

/// The property for the path that will be drawn
struct Path {
    
    /// The mutable path
    var path: CGMutablePath
    
    /// The color of the path
    var color: UIColor
    
    /// The width of the path line
    var width: CGFloat
    
    /// The opacity to be drawn
    var opacity: CGFloat
    
    /// initializer
    init(path: CGMutablePath, color: UIColor, width: CGFloat, opacity: CGFloat) {
        self.path    = path
        self.color   = color
        self.width   = width
        self.opacity = opacity
    }
}
