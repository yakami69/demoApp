//
//  AppCoordinator.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/11/20.
//

import Foundation
import Combine
import UIKit
import Framework

final class AppCoordinator: BaseCoordinator {
    
    /// The main route for the app
    private let route: Route
    
    
    /// the dispose bag
    var bag = Set<AnyCancellable>()
    
    /// Initializer
    init(route: Route) {
        self.route = route
        super.init()
    }
    
    /// Start the coordinator process
    override func start(with deepLink: DeepLink?) {
        
    }
    
    /// Method that handles the initial route redirection logic
    /// - Parameter deeplink: deeplink if available

    
    /// Run the auth coordinator
    private func runAuthCoordinator(deeplink: DeepLink?) {
//        let coordinator = AuthCoordinator(route: route, userManager: userManager, cacheManager: cacheManager)
//        coordinator.onFinish = { [unowned self] in
//            self.performRedirection()
//        }
//        coordinate(to: coordinator, deepLink: deeplink)
    }
    
    private func showOnboarding() {
        
        // Instantiate
//        let onboardingView = OnboardingView()
//        let onboardingViewModel = OnboardingViewModel()
//        let onboardingController = OnboardingController(baseView: onboardingView, baseViewModel: onboardingViewModel)
//
//        /// Observe Triggers
//        onboardingViewModel.trigger.sink { [weak self] (route) in
//            guard let self = self else { return }
//            self.handleRouteTrigger(route)
//        }.store(in: &onboardingViewModel.bag)
//
//        route.push(onboardingController, animated: true)
    }
    
    private func showDashboard() {
        
    }
    
    private func handleRouteTrigger(_ trigger: AppRoutable) {
        switch trigger {

        default:
            break
        }
    }
}
