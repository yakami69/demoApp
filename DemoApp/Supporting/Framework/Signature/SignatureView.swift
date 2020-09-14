//
//  SignatureView.swift
//  
//
//  Created by Narendra Bdr Kathayat on 2/20/20.
//

import UIKit
import Combine

open class SignatureView: UIView {
    
    // MARK: - properties
    /// The configurations for the signature
    private var config = SignatureConfig.default
    
    /// The array of path drawn
    private var drawnPaths: [Path] = [] {
        didSet {
            hasSignature.send(!drawnPaths.isEmpty)
        }
    }
    
    /// The current point of touch
    private var currentPoint = CGPoint()
    
    /// The previous point of touch
    private var previousPoint = CGPoint()
    
    /// The last point of touch before new touch
    private var lastPoint = CGPoint()
    
    /// Flag top indicate if we actually have the signature
    public var hasSignature = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Initializers
    
    /// Private init so that we can focus on convenience intializer
    override private init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    /// System required init which we won't use
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    /// The convenience initializer for this view
    /// - Parameter config: the path configuartions
    required convenience public init(_ config: SignatureConfig) {
        self.init(frame: .zero)
        self.config = config
        self.backgroundColor = UIColor.clear
    }
    
    /// Draw the path
    override open func draw(_ rect: CGRect) {
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        drawnPaths.forEach {
            context.setLineWidth($0.width)
            context.setAlpha($0.opacity)
            context.setStrokeColor($0.color.cgColor)
            context.addPath($0.path)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            context.strokePath()
            context.endTransparencyLayer()
        }
    }
    
    /// Method to undo the last path
    public func undo() {
        drawnPaths.removeLast()
        setNeedsDisplay()
    }
    
    /// Method to clear the signature
    public func clear() {
        drawnPaths = []
        setNeedsDisplay()
    }
    
    /// Method to take the snapshot of the signature view and create image for processing
    public func getSignature() -> Signature? {
        guard hasSignature.value else { return nil }
        guard let signatureImage = snap() else { return nil }
        return Signature(signature: signatureImage)
    }
}

// MARK: - The touch handlers
extension SignatureView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // return if we just need to plot and not draw or we didn't get the touch properly
        guard config.canDraw, let touch = touches.first else { return }
        
        // set the touches
        setTouchPoints(touch, view: self)
        
        // prepare the path structure
        let newPath = Path(path: CGMutablePath(), color: config.lineColor, width: config.lineWidth, opacity: config.lineOpacity)
        
        // add interpolated curved path to the new path
        newPath.path.addPath(createNewPath())
        
        // set the drawn array with new path
        drawnPaths.append(newPath)
    }
    
    /// When touches moves
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // return if we just need to plot and not draw or we didn't get the touch properly
        guard config.canDraw, let touch = touches.first else { return }
        
        // update the touch points
        updateTouchPoints(touch, view: self)
        
        // set the last path to new line drawn
        let newLine = createNewPath()
        if let currentPath = drawnPaths.last {
            currentPath.path.addPath(newLine)
        }
    }
}

extension SignatureView {
    
    /// Method to set the touch points
    /// - Parameters:
    ///   - touch: the touch instance
    ///   - view: the view for the touch
    private func setTouchPoints(_ touch: UITouch,view: UIView) {
        previousPoint = touch.previousLocation(in: view)
        lastPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    /// Method to updates the touch points when touches moves
    /// - Parameters:
    ///   - touch: the touch to update
    ///   - view: tghe view for the touch
    private func updateTouchPoints(_ touch: UITouch,view: UIView) {
        lastPoint = previousPoint
        previousPoint = touch.previousLocation(in: view)
        currentPoint = touch.location(in: view)
    }
    
    /// Method to create a new path from the touch
    private func createNewPath() -> CGMutablePath {
        
        /// get the mid points of last point and previous point
        let midOne = previousPoint.midPoint(fromPoint: lastPoint)
        
        /// get the mid point between current and previous point
        let midTwo = currentPoint.midPoint(fromPoint: previousPoint)
        
        /// draw curve from second mid point moving to first mid point
        let subPath = createSubPath(midOne, mid2: midTwo)
        
        /// set the curved path as the subpath
        let newPath = addSubPathToPath(subPath)
        
        /// return path
        return newPath
    }
    
    /// Method to create the subpath with curve from given mid points
    /// - Parameters:
    ///   - mid1: the point to move to
    ///   - mid2: the point that will be curved
    private func createSubPath(_ mid1: CGPoint, mid2: CGPoint) -> CGMutablePath {
        let subpath : CGMutablePath = CGMutablePath()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint.x, y: previousPoint.y))
        return subpath
    }
    
    /// Method to add a subpath to current drawing path
    /// - Parameter subpath: the subpath to add
    private func addSubPathToPath(_ subpath: CGMutablePath) -> CGMutablePath {
        let bounds : CGRect = subpath.boundingBox
        let drawBox : CGRect = bounds.insetBy(dx: -2.0 * config.lineWidth, dy: -2.0 * config.lineWidth)
        setNeedsDisplay(drawBox)
        return subpath
    }
}
