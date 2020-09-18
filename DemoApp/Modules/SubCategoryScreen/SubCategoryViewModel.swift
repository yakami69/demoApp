//
//  SubCategoryViewModel.swift
//  DemoApp
//
//  Created by Mahesh Yakami on 9/18/20.
//  Copyright © 2020 Mahesh Yakami. All rights reserved.
//

import UIKit
import Framework
import Combine

class SubCategoryViewModel: BaseViewModel {
    
    var category: Category
    
    init(category: Category) {
        self.category = category
        
    }
    
}
