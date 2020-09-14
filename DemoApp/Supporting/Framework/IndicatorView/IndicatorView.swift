//
//  IndicatorView.swift
//  
//
//  Created by Narendra Kathayat on 4/28/20.
//

import UIKit

open class IndicatorView: UIView {

    /// The top and bottom space padded
    var padding: CGFloat = 10.0
    
    /// The color of the indicator
   public var indicatorColor: UIColor = .white

    /// The diameter of the circular indicator
    private lazy var indicatorDiameter: CGFloat = {
        return self.bounds.height - (padding * 2)
    }()
    
    /// initialize with frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// The animating layer
    private var animator: CAShapeLayer!
    
    /// Shows the indicator
    open func showIndicator() {
        animator = getAnimatorLayer()
        animator.add(getRotatingAnimation(), forKey: "Rotator")
        layer.addSublayer(animator)
    }
    
    /// hides the indicator
    open func hideIndicator() {
        if animator != nil {
            animator.removeAllAnimations()
            animator.removeFromSuperlayer()
        }
        animator = nil
    }

    /// The animator layer
    private func getAnimatorLayer() -> CAShapeLayer {
        let xFromCenter = (bounds.width / 2.0 - indicatorDiameter / 2.0)
        let yFromCenter = (bounds.height - indicatorDiameter) / 2.0
        let smallRect = CGRect(x: xFromCenter, y: yFromCenter, width: indicatorDiameter, height: indicatorDiameter)
        let path = UIBezierPath(arcCenter: CGPoint(x: smallRect.width / 2.0, y: smallRect.height / 2.0), radius: indicatorDiameter / 2.0, startAngle: .pi, endAngle: (2 * .pi), clockwise: true)
        let shape = CAShapeLayer()
        shape.frame = smallRect
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = indicatorColor.cgColor
        shape.lineWidth = 2.0
        return shape
    }

    /// The basic rotating animation
    private func getRotatingAnimation() -> CABasicAnimation {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.isRemovedOnCompletion = false
        return rotateAnimation
    }
}
