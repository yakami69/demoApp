//
//  DashboardController.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/15/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import Foundation
import Framework

class DashboardController: AppBaseController {
    /// View
     private lazy var dashboardcreenView: DashboardView = {
         return baseView as! DashboardView //swiftlint:disable:this force_cast
     }()
     
     /// View Model
     private lazy var dashboardviewModel: DashboardViewModel = {
         return baseViewModel as! DashboardViewModel //swiftlint:disable:this force_cast
     }()
}
