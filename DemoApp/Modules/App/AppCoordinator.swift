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
        showDashboard()
    }
    
    
    private func showDashboard() {

        let dashboardView = DashboardView()
        let dashboardViewModel = DashboardViewModel()
        let dashboardController = DashboardController(baseView: dashboardView, baseViewModel: dashboardViewModel)
        
        /// Observe Triggers
        dashboardViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &dashboardViewModel.bag)
        
        route.setRoot(dashboardController, animated: true)
    }
    
    private func handleRouteTrigger(_ trigger: AppRoutable) {
        switch trigger {

        default:
            break
        }
    }
}
