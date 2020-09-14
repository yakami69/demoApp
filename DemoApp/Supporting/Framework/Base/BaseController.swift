//
//  BaseController.swift
//  
//
//  Created by Narendra Kathayat on 4/28/20.
//

import UIKit
import Foundation

/// The parent of all controller inside app
open class BaseController: UIViewController {
    
    /// The baseView of controller
    public let baseView: BaseView
    
    /// The baseViewModel of controller
    public let baseViewModel: BaseViewModel
    
    /// when view is loaded
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        /// setup UI
        setupUI()
        
        /// observe events
        observeEvents()
    }
    
    /// Initializer for a controller
    /// - Parameters:
    ///   - baseView: the view associated with the controller
    ///   - baseViewModel: viewModel associated with the controller
    public init(baseView: BaseView, baseViewModel: BaseViewModel) {
        self.baseView = baseView
        self.baseViewModel = baseViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Not available
    required public init?(coder: NSCoder) {
        fatalError("Controller should never be instantiated from coder")
    }
    
    /// Load the base view as the view of controller
    override open func loadView() {
        super.loadView()
        view = baseView
    }
    
    /// setup trigger
    open func setupUI() {}
    
    /// Observer for events
    open func observeEvents() {}
    
    /// Deint call check
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
}

extension BaseController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    ///   - titleAttributes: attributes to be display for title of alert
    ///   - messageAttribute: attributes for the message of alert
    ///   - completion: action completion handler
    open func alert(title: String, msg: String, actions: [AlertActionable], titleAttributes: [NSAttributedString.Key: Any]? = nil, messageAttribute: [NSAttributedString.Key: Any]? = nil, completion: ((_ action: AlertActionable) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if let attributes = titleAttributes {
            //attributed title
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        if let attributes = messageAttribute {
            /// Attributed message
            let attributedMsg = NSAttributedString(string: msg, attributes: attributes)
            alert.setValue(attributedMsg, forKey: "attributedMessage")
        }
        
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                completion?(action)
            }
            alert.addAction(alertAction)
        }
        present(alert, animated: true, completion: nil)
    }
}
