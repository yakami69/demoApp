//
//  AlertActionable.swift
//  
//
//  Created by Narendra Kathayat on 4/28/20.
//

import Foundation
import UIKit

public protocol AlertActionable {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
