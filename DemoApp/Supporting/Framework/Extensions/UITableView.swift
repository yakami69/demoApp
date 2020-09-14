//
//  UITableView.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import UIKit

public extension UITableView {

    /// register class for a cell.
    ///
    /// - Parameter cellType: cell to register
    func registerClass<C>(_ cell: C.Type) where C: UITableViewCell {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
    
    /// Helper method to easily resolve and register the HeaderFooterView for UITableView
    /// - Parameter view: the UITableViewHeaderFooterView subclass
    func registerHeaderFooterClass<C>(_ view: C.Type) where C: UITableViewHeaderFooterView {
        register(view, forHeaderFooterViewReuseIdentifier: view.identifier)
    }
}
