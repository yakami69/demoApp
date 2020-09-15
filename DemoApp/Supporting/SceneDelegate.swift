//
//  SceneDelegate.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/12/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// The app launcher
    let appLaunchBuilder = AppLaunchBuilder.default

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if window == nil { window = UIWindow(windowScene: windowScene) }
        appLaunchBuilder.generateApplicationState(with: window, deepLink: nil)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        if let framework = appLaunchBuilder.framework {
            _ = framework.open(url: url, application: UIApplication.shared, options: [:])
        }
    }
}

