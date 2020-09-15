//
//  AppBaseController.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 8/12/20.
//

import UIKit
import Framework

enum BaseBarButton: Int {
    case back = 100
    case menu = 101
    case notification = 102
    case edit = 103
}

typealias UICollectionViewDelegats = UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate

class AppBaseController: BaseController {
    
    /// The backButton
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        button.tag = BaseBarButton.back.rawValue
        return button
    }()
    
    lazy var menuButton:  UIBarButtonItem = {
        let button = UIBarButtonItem(image: .back, style: .plain, target: self, action: #selector(backButtonClicked))

        button.tag = BaseBarButton.menu.rawValue
        return button
    }()
    
    var showLeftBarButton = true
    
    /// Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// decide the left button for menu or back
       if let navigationController = self.navigationController {
            let count = navigationController.viewControllers.count
            if count > 1 && showLeftBarButton {
                navigationItem.leftBarButtonItem = backButton
            } else if showLeftBarButton {
                // put other button for left nav if required
                navigationItem.leftBarButtonItem = menuButton
            }
        }
    }
    /// make the status bar light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// When backbutton is clicked
    @objc func backButtonClicked(sender: UIBarButtonItem) {
        if sender.tag == BaseBarButton.back.rawValue {
            pop()
            return
        }

    }
    
    public func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    
    func progressAlert() {
        alert(title: LocalizedKey.appName.value, msg: "Work on progress", actions: [Constant.AlertAction.ok])
    }
    
    func shareTextContent(sharableText: String) {
        let activityViewController = UIActivityViewController(activityItems: [sharableText], applicationActivities: nil)
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
