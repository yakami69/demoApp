//
//  BusinessDetailScreenViewModel.swift
//  Demo App
//
//  Created by Mahesh Yakami on 1/9/20.
//

import Foundation
import Kingfisher
import Framework

class BusinessDetailScreenViewModel : BaseViewModel {
    
    var businessInfo: Business
    var imageUrl : URL
    
    init(businessInfo: Business) {
        self.businessInfo = businessInfo
        self.imageUrl = URL(string: businessInfo.businessImageURL!)!
        super.init()
    }
    
    
}
