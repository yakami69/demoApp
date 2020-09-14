//
//  IAPProductIdentifiable.swift
//  Framework
//
//  Created by Narendra Kathayat on 8/21/20.
//  Copyright © 2020 EBPearls. All rights reserved.
//

import Foundation

public protocol IAPProductIdentifiable {
    var identifier: String { get }
    var term: PaymentTerm { get }
}
