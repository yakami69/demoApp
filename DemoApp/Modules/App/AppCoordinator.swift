//
//  AppCoordinator.swift
//  Demo App
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
        
        let dashboardView = CategoryListView()
        let dashboardViewModel = DashboardViewModel()
        let dashboardController = DashboardController(baseView: dashboardView, baseViewModel: dashboardViewModel)
        
        /// Observe Triggers
        dashboardViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &dashboardViewModel.bag)
        
        route.setRoot(dashboardController, animated: true)
    }
    
    private func showSubCategoryView(category: Category) {
        let howSubCategoryView = CategoryListView()
        let howSubCategoryViewModel = SubCategoryViewModel(category: category)
        let howSubCategoryController = SubCategoryController(baseView: howSubCategoryView, baseViewModel: howSubCategoryViewModel)
        
        /// Observe Triggers
        howSubCategoryViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &howSubCategoryViewModel.bag)
        
        route.push(howSubCategoryController, animated: true)
    }
    
    private func showBusinessList() {
        let dashboardView = CategoryListView()
        let dashboardViewModel = DashboardViewModel()
        let dashboardController = DashboardController(baseView: dashboardView, baseViewModel: dashboardViewModel)
        
        /// Observe Triggers
        dashboardViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &dashboardViewModel.bag)
        
        route.push(dashboardController, animated: true)
    }
    
    private func showBusinessDetailScreen(business: Business) {
        let businessDetailScreenViewModel = BusinessDetailScreenViewModel(businessInfo: business)
        let businessDetailScreenView = BusinessDetailScreenView()
        let businessDetailScreenViewController = BusinessDetailScreenViewController(baseView: businessDetailScreenView, baseViewModel: businessDetailScreenViewModel)
        
        businessDetailScreenViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &businessDetailScreenViewModel.bag)
        
        route.push(businessDetailScreenViewController, animated: true)
    }
    
    private func showBusinessListScreen(business: [Business], title: String) {
        let businessListViewModel = BusinessListViewModel(business: business,title: title)
        let businessListView = BusinessListView()
        let businessListController = BusinessListController(baseView: businessListView, baseViewModel: businessListViewModel)
        
        businessListViewModel.trigger.sink { [weak self] (route) in
            guard let self = self else { return }
            self.handleRouteTrigger(route)
        }.store(in: &businessListViewModel.bag)
        
        route.push(businessListController, animated: true)
    }
    
    private func handleRouteTrigger(_ trigger: AppRoutable) {
        switch trigger {
        case AppRoute.subCategory(let category):
            showSubCategoryView(category: category)
        case AppRoute.businessDetail(let businessInfo):
            showBusinessDetailScreen(business: businessInfo)
        case AppRoute.businessList(let business, let title):
            showBusinessListScreen(business: business, title: title)
        default:
            break
        }
    }
}
