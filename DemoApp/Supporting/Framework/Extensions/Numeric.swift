//
//  Numeric.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import Foundation
import UIKit

public extension CGFloat {
    /// cgfloat to radians
    var radian: CGFloat {
        return self * .pi / 180.0
    }
}

public extension Double {
    /// cgfloat to radians
    var radian: Double {
        return self * .pi / 180.0
    }
}
