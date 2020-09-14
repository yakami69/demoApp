//
//  UIViewController.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import UIKit

// MARK: - Making UIviewController confirms to presentable
extension UIViewController: Presentable {
    public var presenting: UIViewController? {
        return self
    }
}

// MARK: - Extract the class name
extension UIViewController {
    public var name: String {
        return String(describing: self)
    }
}
