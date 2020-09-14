//
//  NSMutableAttributedString.swift
//  
//
//  Created by Mukesh Awal on 2/18/20.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    /// adds attributes specified in parameters to NSMutableString
    /// - Parameters:
    ///   - fontStyle: font style
    ///   - lineHeight: line height
    ///   - textColor: text color
    ///   - characterSpacing: character spacing
    ///   - alignment: allignment
    ///   - lineBreakMode: line break mode
    func addAttributes(fontStyle: UIFont, lineHeight: CGFloat? = nil, textColor: UIColor = UIColor.white, characterSpacing: Double = 0.0, alignment: NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping) {

        let attributedDict = Attribute.getAttributes(fontStyle: fontStyle, lineHeight: lineHeight, textColor: textColor, characterSpacing: characterSpacing, alignment: alignment, lineBreakMode: lineBreakMode)

        self.addAttributes(attributedDict, range: NSRange(location: 0, length: self.string.count))
    }
}

