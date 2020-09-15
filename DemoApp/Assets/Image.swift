//
//  Image.swift
//  TipQuick
//
//  Created by Narendra Kathayat on 8/11/20.
//  Copyright © 2020 Ebpearls. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Helper method to verify and get the image with given name
    /// - Parameter imageName: the name of image from asset
    /// - Returns: the image from given name
    private static func named(_ imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName) else {
            assertionFailure("The image associated with name \(imageName) was not found. Please check you have spelled it correctly.")
            return UIImage()
        }
        return image
    }
    
    /// The back button icon
    static var back: UIImage? { return UIImage.named("backArrow") }
    static var locationFocus: UIImage? { return UIImage.named("locationFocus")}
    static var share: UIImage? { return UIImage.named("share")}
    static var eyeoff: UIImage? { return UIImage.named("eye-off") }
    static var eyeon: UIImage? { return UIImage.named("eye-on") }
    static var marker: UIImage? { return UIImage.named("marker") }
    static var orangeMarker: UIImage? { return UIImage.named("orangeMarker") }
    static var currentLocationMarker: UIImage? { return UIImage.named("currentLocationMarker") }
    static var splashBackground: UIImage? { return UIImage.named("splashBackground") }
    static var tipQuickLogoOrangeWhite: UIImage? { return UIImage.named("tipQuickLogoOrangeWhite") }
    static var tipQuickLogoOrangeBlue: UIImage? { return UIImage.named("tipQuickLogoOrangeBlue") }
    static var pin: UIImage? { return UIImage.named("pin") }
    static var like: UIImage? { return UIImage.named("like") }
    static var van: UIImage? { return UIImage.named("van") }
    static var cluster: UIImage? { return UIImage.named("cluster") }
    static var placeNav: UIImage? { return UIImage.named("placeNav") }
    static var facebookLogo: UIImage? { return UIImage.named("facebookLogo") }
    static var googleLogo: UIImage? { return UIImage.named("googleLogo") }
    static var appleLogo: UIImage? { return UIImage.named("appleLogo") }
    static var notificationBell: UIImage? { return UIImage.named("notificationBell")}
    static var cancelWithRedBG: UIImage? { return UIImage.named("cancelWithRedBG") }
    static var retry: UIImage? { return UIImage.named("retry") }

    
    static var threeDots: UIImage? { return UIImage.named("threeDots")}
    
    // the premium feature 1 image
    static var premiumFeature1: UIImage { return UIImage.named("premiumFeature1") }
    
    // the tab bar home image
    static var tabHome: UIImage? { return UIImage.named("tabHome") }
    
    // the tab bar settings image
    static var tabSettings: UIImage? { return UIImage.named("tabSettings") }
    
    // the logout arrow image
    static var logout: UIImage? { return UIImage.named("logout") }
    
    // the shadow image
    static var shadowImage: UIImage? { return UIImage.named("shadowImage") }
    
    /// internet icon
    static var internet: UIImage? { return UIImage.named("internet") }
    
    /// mail icon
    static var mail: UIImage? { return UIImage.named("mail") }
    
    /// marker pin
    static var markerPin: UIImage? { return UIImage.named("markerpin") }
    
    /// phone icon
    static var phone: UIImage? { return UIImage.named("phone") }
    
    /// cross image
    static var cross: UIImage? { return UIImage.named("cross") }
    
    /// search icon
    static var search: UIImage? { return UIImage.named("search") }
    
    /// tool
    static var tool: UIImage { return UIImage.named("tool") }
    //  camera 
    static var camera: UIImage { UIImage.named("camera") }
    
    func setTemplate() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
