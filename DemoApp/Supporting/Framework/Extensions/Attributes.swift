//
//  Attributes.swift
//  
//
//  Created by Mukesh Awal on 2/18/20.
//

import UIKit

public struct Attribute {
    /// font atribute generator to apply to NSattributedStrings. returns [NSMutableAttributedString.Key: Any]
    /// - Parameters:
    ///   - fontStyle: UIFont
    ///   - textColor: text color defaults to white
    ///   - lineHeight: line height
    ///   - characterSpacing: character spacing or kern
    ///   - alignment: allignment
    ///   - lineBreakMode: line break mode
    public static func getAttributes(fontStyle: UIFont, lineHeight: CGFloat? = nil, textColor: UIColor = UIColor.white, characterSpacing: Double = 0.0, alignment: NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping) -> [NSAttributedString.Key : Any]{

        let paraStyle = NSMutableParagraphStyle()

        if let lineHt = lineHeight {
            paraStyle.maximumLineHeight = lineHt
            paraStyle.minimumLineHeight = lineHt
        } else {
            paraStyle.maximumLineHeight = fontStyle.pointSize + 1
            paraStyle.minimumLineHeight = fontStyle.pointSize + 1
        }
        paraStyle.alignment = alignment
        paraStyle.lineBreakMode = lineBreakMode

        let attributeDict: [NSMutableAttributedString.Key: Any] = [
            .font: fontStyle,
            .paragraphStyle: paraStyle,
            .foregroundColor: textColor,
            .kern: characterSpacing
        ]

        return attributeDict
    }
}
