//
//  Localization.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/13/20.
//

import Foundation

private protocol Localizable {
    var key: String { get }
    var value: String { get }
}

private struct Localizer {
    static func localized(key: Localizable, bundle: Bundle = .main, tableName: String = "English", value: String = "", comment: String = "", param: String = "") -> String {
        let value = String(format: NSLocalizedString(key.key, tableName: tableName, bundle: bundle, value: value, comment: comment), param)
        return value
    }
}

enum LocalizedKey: Localizable {
    case none
    case appName
    case ok
    case yes
    case cancel
    
    /// The key to fetch the corresponding localized string
    var key: String {
        switch self {
        case .none: return "NONE"
        case .appName: return "APP_NAME"
        case .ok: return "OK"
        case .yes: return "YES"
        case .cancel: return "CANCEL"
        
        }
    }
    
    /// The stringified value from localization of the key
    var value: String {
        switch self {
//        case .required(let text), .validRequired(let text), 
//            return Localizer.localized(key: self, param: text)
        default:
            return Localizer.localized(key: self)
        }
    }
}
