//
//  File.swift
//  
//
//  Created by Narendra Kathayat on 4/28/20.
//

import UIKit

/// The base view to be inherited by all screen child
open class BaseView: UIView {
    
    /// The size of the view indicator
    private var indicatorDimension = CGSize(width: 55.0, height: 55.0)
    
    /// The indicatorView
    private var indicatorView: IndicatorView?
    
    /// flag to check if the indicator is indicating or not
    private var indicating: Bool = false
    
    /// indicator color
    public var indicatorColor: UIColor = .black
    
    /// Flag to display or hide the indicator
    public var indicate: Bool = false {
        didSet {
            if indicate {
                startIndicator()
            } else {
                endIndicator()
            }
        }
    }
    
    /// The freeze view
    private lazy var freezerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Frame Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    /// Coder initializer
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    /// base function to create the subviews
    /// This function is override by different views to create their own subviews
    open func create() {
        self.backgroundColor = .white
    }
    
    /// This method will add a non interactive, non visible overlay over the screen so that all elements appears to be disabled
    public func freezeAll() {
        
        addSubview(freezerView)
        
        NSLayoutConstraint.activate([
            freezerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            freezerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            freezerView.topAnchor.constraint(equalTo: topAnchor),
            freezerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    /// This method will remove the freezer view from screen
    public func unFreezeAll() {
        freezerView.removeConstraints(freezerView.constraints)
        freezerView.removeFromSuperview()
    }
    
    /// Method that will add a indicator
    private func startIndicator() {
        guard let indicator = indicatorView else { return }
        addSubview(indicator)
        indicator.showIndicator()
        bringSubviewToFront(indicator)
        indicating = true
    }
    
    /// Method that will remove the indicator
    private func endIndicator() {
        guard let indicator = indicatorView else { return }
        indicator.hideIndicator()
        indicator.removeFromSuperview()
        indicating = false
    }
    
    /// Achive the rect of view
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // check if already indicating
        if !indicating {
            
            /// initialize the indicator when rect is achieved
            self.indicatorView = IndicatorView(frame: CGRect(x: (rect.midX - (indicatorDimension.width / 2.0)), y: rect.midY - (indicatorDimension.height / 2.0), width: indicatorDimension.width, height: indicatorDimension.width))
            self.indicatorView?.indicatorColor = indicatorColor
            
            /// start the indicator if set
            if indicate {
                self.startIndicator()
            }
        }
    }
    
    /// Deint call check
    deinit {
        debugPrint("De-Initialized --> \(String(describing: self))")
    }
}
