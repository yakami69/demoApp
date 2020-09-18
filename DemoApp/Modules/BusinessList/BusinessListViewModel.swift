//
//  BusinessListViewModel.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/19/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit
import Framework

class BusinessListViewModel: BaseViewModel {
    
    var business: [Business]
    
    var title: String
    
    init(business: [Business], title: String) {
        self.business = business
        self.title = title
    }
}
