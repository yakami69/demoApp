//
//  Constant.swift
//  Demo App
//
//  Created by Mahesh Yakami on 8/11/20.
//

import UIKit
import Framework

enum Constant {
    

    /// enum for Cache keys
    enum CacheKey: String, CacheKeyable {
        case appLaunched
        
        var name: String { return self.rawValue }
    }
    
    /// Alert button title
    enum AlertAction: AlertActionable {
        case ok
        case cancel
        case yes
        
        var title: String {
            switch self {
            case .ok: return LocalizedKey.ok.value
            case .cancel: return LocalizedKey.cancel.value
            case .yes: return LocalizedKey.yes.value
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            default:
                return UIAlertAction.Style.default
            }
            
        }
    }
    
    enum appInfo {
        static var bundleId: String = ""
    }

}

enum ConstraintConstant {
    case buttonHeight
    case zero
    case base8
    case base16
    case base20
    case base25
    case base30
    case base32
    case base33
    case base77
    case base44
    case base98
    case buttonWidth
    case base24
    case base27
    case base50
    case base148
    
    var value: CGFloat {
        switch self {
        case .buttonHeight:
            return 57.0
        case .zero:
            return 0
        case .base8:
            return 8.0
        case .base16:
            return 16.0
        case .base32:
            return 32.0
        case .base33:
            return 33.0
        case .buttonWidth:
            return 115.0
        case .base24:
            return 24.0
        case .base44:
            return 44.0
        case .base50:
            return 50.0
        case .base77:
            return  77.0
        case .base98:
            return 98.0
        case .base20:
            return 20.0
        case .base30:
            return 30.0
        case .base148:
            return 148.0
            
        case .base25:
            return 25.0
        case .base27:
            return 27.0
        }
    }
}
