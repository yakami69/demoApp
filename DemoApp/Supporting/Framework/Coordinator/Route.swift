//
//  Route.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import UIKit

/// The rout helper class for the coordinators
final public class Route {
    
    /// The rootController of the route
    public weak var rootController: UIViewController?
    
    /// Initializer to setup router with root controller
    ///
    /// - Parameter rootController: Root Controller (Base Navigation Controller)
    public init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    /// Deinitializer for the route
    deinit {
        self.rootController = nil
    }
}

// MARK: - Push / Pop / setRoot
extension Route {
    
    /// Sets the controller as the root of rootController if the rootcontroller is navigation controller
    ///
    /// - Parameters:
    ///   - presentable: the controller to be set as root view controller
    ///   - animated: is the transition animated
    ///   - hideBar: will the navigation bar be hidden
    public func setRoot(_ presentable: Presentable?, animated: Bool = false, hideBar: Bool = true) {
        
        guard let navigationController = rootController as? UINavigationController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        navigationController.isNavigationBarHidden = hideBar
        if hideBar {
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationItem.largeTitleDisplayMode = .never
        }
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    /// Present a controller on the routes root controller
    /// - Parameter presentable: the presenting controller
    public func present(_ presentable: Presentable?, animated: Bool = true) {
        guard let navigationController = rootController as? UINavigationController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.present(controller, animated: animated, completion: nil)
    }
    
    
    /// Dismiss the presented route
    /// - Parameter animated: the transition should be animated or not
    public func dismiss(animated: Bool = true) {
        guard let navigationController = rootController else {
            assertionFailure("Please properly check that controller and navigation controller both are provided")
            return
        }
        navigationController.dismiss(animated: animated, completion: nil)
    }
    
    /// Push the controller on navigation stack if the root of the route is navigation controller
    ///
    /// - Parameters:
    ///   - presentable: the controller to push
    ///   - animated: animated or not
    public func push(_ presentable: Presentable?, animated: Bool = true) {
        guard let navigationController = rootController as? UINavigationController,
            let controller = presentable?.presenting else {
                assertionFailure("Please properly check that controller and navigation controller both are provided")
                return
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    /// Pop the stack to specific controller
    /// - Parameters:
    ///   - controller: the controller to pop to
    ///   - animated: is the transition animated
    public func popTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) {
        guard let navigationController = rootController as? UINavigationController else {
            assertionFailure("Please properly check that navigation controller is present as the root of router")
            return
        }
        
        /// find the controller to pop to
        for controller in navigationController.viewControllers where controller is T {
             navigationController.popToViewController(controller, animated: animated)
        }
    }
    
    /// The method to pop the controller from navigation stack, if the root of route is navigation controller
    ///
    /// - Parameter animated: animated or not
    public func pop(animated: Bool = true) {
        guard let navigationController = rootController as? UINavigationController else {
            assertionFailure("Please properly check that navigation controller is present as the root of router")
            return
        }
        navigationController.popViewController(animated: animated)
    }
    
    /// Pop all the controller from navigtaion stack keeping only the first (root), if the root of the routre is navigation controller
    ///
    /// - Parameter animated: animated or not
    public func popToRoot(animated: Bool = true) {
        guard let navigationController = rootController as? UINavigationController else {
            assertionFailure("Please properly check that navigation controller is present as the root of router")
            return
        }
        navigationController.popToRootViewController(animated: animated)
    }
}
