//
//  AlchemyCheckbox.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 7/27/19.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import UIKit

@IBDesignable
public class AlchemyCheckbox: UIControl
{
    
    ///Used to choose the shape for the Checkbox
    public enum CheckType: Int
    {
        /// ■
        case square
        /// ●
        case circle
        /// x
        case cross
        /// ✓
        case tick
    }
    
    /// Shape of the outside box containing the checkmarks contents.
    /// Used as a visual indication of where the user can tap.
    public enum BorderStyle: Int
    {
        /// ▢
        case square
        /// ■
        case roundedSquare
        /// ◯
        case rounded
    }
    
    @IBInspectable
    public var checkTypeInt: Int  = CheckType.circle.rawValue
    {
        didSet
        {
            if let newShape = CheckType(rawValue: checkTypeInt)
            {
                checkType = newShape
            }
        }
    }
    
    public var checkType: CheckType = .circle
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var borderStyleInt: Int = BorderStyle.roundedSquare.rawValue
    {
        didSet
        {
            if let newBorderStyle = BorderStyle(rawValue: borderStyleInt)
            {
                borderStyle = newBorderStyle
            }
        }
    }
    
    public var borderStyle: BorderStyle = .roundedSquare
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var corderRadius: CGFloat = 4
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.75
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    public var checkmarkSize: CGFloat = 0.5
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    //Used to increase the touchable are for the component
    public var increasedTouchRadius: CGFloat = 5
    
    //By default it is true
    public var useHapticFeedback: Bool = true
    
    @IBInspectable
    public var isChecked: Bool = false
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    //UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    //MARK: Intialisers
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    //Define the above UIImpactFeedbackGenerator object, and prepare the engine to be ready to provide feedback.
    //To store the energy and as per the best practices, we create and make it ready on touches begin.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }
    
    //On touches ended,
    //change the selected state of the component, and changing *isChecked* property, draw methos will be called
    //So components appearance will be changed accordingly
    //Hence the state change occures here, we also sent notification for value changed event for this component.
    //After usage of feedback generator object, we make it nill.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.isChecked = !isChecked
        self.sendActions(for: .valueChanged)
        
        if useHapticFeedback
        {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    open override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }
    
    //we override the following method,
    //To increase the hit frame for this component
    //Usaully check boxes are small in our app's UI, so we need more touchable area for its interaction
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
}

//=========================================
//MARK: DRAWING
//=========================================
extension AlchemyCheckbox
{
    func makeImage(from context: CGContext) -> UIImage?
    {
        guard let image = context.makeImage() else { return nil }
        return UIImage(cgImage: image)
    }
    
    public override func draw(_ rect: CGRect)
    {
        //Draw the outlined component
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setLineWidth(borderWidth)
        
        var shapePath: UIBezierPath
        switch self.borderStyle
        {
            case .square:
                shapePath = UIBezierPath(rect: newRect)
            case .roundedSquare:
                shapePath = UIBezierPath(roundedRect: newRect, cornerRadius: self.corderRadius)
            case .rounded:
                shapePath = UIBezierPath(ovalIn: newRect)
        }
        
        let beforeImage = makeImage(from: context)
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        let imageAfter = makeImage(from: context)
        
        //When it is selected, depends on the style
        //By using helper methods, draw the inner part of the component UI.
        if isChecked
        {
            
            switch self.checkType
            {
                case .square:
                    self.drawInnerSquare(frame: newRect)
                
                case .circle:
                    self.drawCircle(frame: newRect)
                
                case .cross:
                    self.drawCross(frame: newRect)
                
                case .tick:
                    self.drawCheckMark(frame: newRect)
            }
        }
    }
}

private extension AlchemyCheckbox
{
    
    //Draws tick inside the component
    func drawCheckMark(frame: CGRect)
    {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }
    
    //Draws circle inside the component
    func drawCircle(frame: CGRect)
    {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX + fastFloor(frame.width * 0.22000 + 0.5), y: frame.minY + fastFloor(frame.height * 0.22000 + 0.5), width: fastFloor(frame.width * 0.76000 + 0.5) - fastFloor(frame.width * 0.22000 + 0.5), height: fastFloor(frame.height * 0.78000 + 0.5) - fastFloor(frame.height * 0.22000 + 0.5)))
        checkmarkColor.setFill()
        ovalPath.fill()
    }
    
    //Draws square inside the component
    func drawInnerSquare(frame: CGRect)
    {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Rectangle Drawing
        let padding = self.bounds.width * 0.3
        let innerRect = frame.inset(by: .init(top: padding, left: padding, bottom: padding, right: padding))
        let rectanglePath = UIBezierPath.init(roundedRect: innerRect, cornerRadius: 3)
        
        checkmarkColor.setFill()
        rectanglePath.fill()
    }
    
    //Draws cross inside the component
    func drawCross(frame: CGRect)
    {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX + fastFloor((frame.width - 17.37) * 0.49035 + 0.5), y: frame.minY + fastFloor((frame.height - 23.02) * 0.51819 - 0.48) + 0.98, width: 17.37, height: 23.02)
        
        //// Group
        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: group.minX + 14.91, y: group.minY)
        context.rotate(by: 35 * CGFloat.pi/180)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: group.minX, y: group.minY + 1.72)
        context.rotate(by: -35 * CGFloat.pi/180)
        
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 3, height: 26))
        checkmarkColor.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()
    }
    
}
