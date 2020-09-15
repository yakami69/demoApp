//
//  AppLaunchBuilder.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/11/20.
//

import UIKit
import IQKeyboardManagerSwift
import Combine
import Framework


final class AppLaunchBuilder {
    
    /// The launch options when app is launched
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    /// The key application or current application
    var application: UIApplication = UIApplication.shared
    
    /// The shared instance
    static let `default` = AppLaunchBuilder()
    private init() {}
    
    /// The framework of the application
    var framework: Framework!
    
    /// The window of the app
    private var window: UIWindow?
    
    /// The main coordinator for the app
    private lazy var appCoordinator: Coordinator = { self.getAppCoordinator() }()
    
    /// the bag
    private var bag = Set<AnyCancellable>()
    
    /// Method to generate new app coordinator when the app launches
    /// - Parameter window: the window for the app
    @discardableResult
    func generateApplicationState(with window: UIWindow?, deepLink: DeepLink?) -> Bool {
        
        /// keep the refrence to window
        self.window = window
        
        // set Keyboard Manager
        setupIQKeyboardManager()
        
        /// initialize the framework
        framework = self.configureFramework()
        

        
        // run the coordinator
        appCoordinator.start(with: deepLink)
       
        //let the app starts
        return true
    }
}

extension AppLaunchBuilder {
    
    /// Method to setup the framework with client configuration
    private func configureFramework() -> Framework {
        
        /// Prepare the configuration
        let clientConfig = ClientConfig { [unowned self] (config) in
            config.application = self.application
            config.environment = self.getEnvironement()
            config.launchOptions = self.launchOptions
        }
        
        /// initialize the framework
        let framework = Framework(config: clientConfig)
        
        /// prepare the framework
        framework.initialize()
        
        // return
        return framework
    }
    
    /// Method to initialize and create the app coordinator for the app
    ///
    /// - Returns: the appcoordinator
    private func getAppCoordinator() -> Coordinator {
        
        //chekc if the window was properly initialized
        guard let window = window else {
            fatalError("Window not initailized properly")
        }
        
        //set the root of window and make window key and visible
        let rootNavigationController = BaseNavigationController()
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        

        return AppCoordinator(route: Route(rootController: rootNavigationController))
    }
    
    /// Method to get environement based on scheme
    private func getEnvironement() -> Environment {
        #if DEBUG
        return Staging()
        #else
        return Live()
        #endif
    }
    
    private func test() {
      //  window?.makeKeyAndVisible()
     //   window?.rootViewController = UINavigationController(rootViewController: ProfileDetailController(baseView: ProfileDetailView(), baseViewModel: ProfileDetailViewModel()))
    }
    
    
    private func setupIQKeyboardManager() {
        /// set IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = .black
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
//        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = []
    }
    
}
