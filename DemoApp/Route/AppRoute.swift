//
//  AppRoute.swift
//  Demo App
//
//  Created by Mahesh Yakami on 8/15/20.
//

import Framework

enum AppRoute: AppRoutable {
    case home
    case finish
    case subCategory(Category)
    case businessList([Business], String)
    case businessDetail(Business)
}

