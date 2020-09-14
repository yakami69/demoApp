//
//  SignatureConfig.swift
//  
//
//  Created by Narendra Bdr Kathayat on 2/24/20.
//

import UIKit

/// The config for the signature path
public struct SignatureConfig {
    
    /// The line color of path/line
    public var lineColor: UIColor
    
    /// The width of signature path/line
    public var lineWidth: CGFloat
    
    /// The opacity of the path/line
    public var lineOpacity : CGFloat
    
    /// The drawing enabled flag to disable drawing if needed
    public var canDraw: Bool
    
    /// The drawing context opaque flag
    public var isOpaque: Bool
    
    /// The private initializer to set the default value to config
    private init() {
        lineColor   = UIColor.black
        lineWidth   = 3.0
        lineOpacity = 1.0
        canDraw     = true
        isOpaque    = true
    }
    
    /// The default configuration of the signature view
    public static var `default`: SignatureConfig {
        return SignatureConfig()
    }
    
    /// Initializer with closure initializer to initialize the configuartions
    /// - Parameter config: the Self instance
    public init(_ config: (SignatureConfig) -> Void) {
        self.init()
        config(self)
    }
}
