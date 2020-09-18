//
//  UIFont.swift
//  Demo App
//
//  Created by Mahesh Yakami on 12/3/19.
//

import UIKit

enum AppFontWeight {
    case black
    case bold
    case book
    case light
}

enum FontType {
    case gotham(AppFontWeight)
    
    fileprivate var name: String {
        switch self {
        case .gotham(let weight):
            switch weight {
            case .black: return "Gotham-Black"
            case .bold: return "Gotham-Bold"
            case .book: return "Gotham-Book"
            case .light: return "Gotham-Light"
            }
        }
    }
}

extension UIFont {
    
    static func appFont(type: FontType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.name, size: size) else {
            fatalError("No font available in the system with this name. Please check")
        }
        return font
    }
}
