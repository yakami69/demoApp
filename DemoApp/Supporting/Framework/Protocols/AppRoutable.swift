//
//  AppRoutable.swift
//  
//
//  Created by Narendra Kathayat on 4/28/20.
//

import Foundation

public protocol AppRoutable {}
public enum SuperTutorRoute: AppRoutable {
    case tutor
    case student
}
