import UIKit
//import FacebookCore

public struct Framework {
    
    /// The configuartion
    private let config: ClientConfig
    
    /// The current application
    private let application: UIApplication
    
    /// The launch options
    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    /// public initilaizer
    public init(config: ClientConfig) {
        self.application = config.application
        self.launchOptions = config.launchOptions
        self.config = config
    }
    
    /// Method that will instantiate the farmework intial classes to work with
    @discardableResult
    public func initialize() -> Bool {
        
        // start the connection observer
        Connection.shared.observe()
        
        // prepare facebook
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /// Initialize coreData database if data available
        if let dataHelper = config.dataHelper {
            CoreDataDatabase.shared.initialize(name: dataHelper.modelName, modelURL: dataHelper.modelURL, entityIdentifier: dataHelper.entityIdentifiers)
        }
        
        /// Enable InApp purchase
        if config.IAPIdentifiers.count > 0 {
            IAPManager.shared.setProducts(availableProducts: config.IAPIdentifiers)
        }
        
        return true
    }
    
    /// This method will used to pass the open url trigger for facebook from main app to the facebook SDK that resides on farmework
    /// - Parameters:
    ///   - url: the url
    ///   - application: the application
    ///   - options: the oprions
    public func open(url: URL, application: UIApplication, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return false //ApplicationDelegate.shared.application(application, open: url, options: options)
    }
}
