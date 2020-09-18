//
//  FontAttributesGenerator.swift
//  Demo App
//
//  Created by Mahesh Yakami on 1/6/20.
//

import Foundation
import UIKit

/// font atribute generator to apply to NSattributedStrings. returns [NSMutableAttributedString.Key: Any]
/// - Parameters:
///   - fontStyle: font name in string defaults to "Gotham-Book"
///   - fontSize: font size in CGFloat defaults to 16
///   - maxLineHeight: maximum line height
///   - textColor: text color defaults to white
func generateFontWith(fontStyle: UIFont, maxLineHeight: CGFloat?, textColor: UIColor = UIColor.white) -> [NSMutableAttributedString.Key: Any] {
    
    let paraStyle = NSMutableParagraphStyle()
    
    if let maxLineHt = maxLineHeight{
        paraStyle.maximumLineHeight = maxLineHt
    }else{
        paraStyle.maximumLineHeight = fontStyle.pointSize + 1
    }
    
    let Attr : [NSMutableAttributedString.Key: Any] = [
        .font : fontStyle,
        .paragraphStyle:paraStyle,
        .foregroundColor: textColor
    ]
    
    return Attr
}

