//
//  Views+.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 7/10/19.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import Foundation
import UIKit

//======================================
//MARK: GENERIC EXTENSIONS
//======================================


/**
 The purpose of this protocol is merely to add
 extension functions to UIViews that support a generic self.
 Oh, Swift....
 */
public protocol U
{
}

extension  UIView: U {}

//=========================================
//MARK: BASIC
//=========================================
public extension UIView
{
    
    convenience init(enableAutoLayout: Bool = true)
    {
        self.init(frame: .zero)
        enableAutoLayout ? enableConstraints() : disableConstraints()
    }
    
    /**
     Removes the automatic resizing constraints, allowing for
     custom constraints using Auto Layout.
     */
    func enableConstraints()
    {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     Enables the automatic resizing constraints, invalidating any
     existing constraints on the view and preventing future
     constraints from being applied.
     */
    func disableConstraints()
    {
        translatesAutoresizingMaskIntoConstraints = true
    }
    
}

//======================================
//MARK: CHANGES
//======================================
public extension UIView
{
    
    var isVisible: Bool
    {
        get
        {
            return !isHidden
        }
        set
        {
            isHidden = !newValue
        }
    }
    
    func hide(animated: Bool = false)
    {
        if animated
        {
            animate(duration: 0.4, effect: .transitionCrossDissolve)
            {
                $0.isHidden = true
            }
        }
        else
        {
            self.isHidden = true
        }
    }
    
    func show(animated: Bool = false)
    {
        if animated
        {
            animate(duration: 0.4, effect: .transitionCrossDissolve)
            {
                $0.isVisible = true
            }
        }
        else
        {
            self.isVisible = true
        }
    }
}


//======================================
//MARK: ANIMATIONS
//======================================
public extension U where Self: UIView
{
    
    /**
     Applies a CGAffineTransform to scale the view to the specified factor,
     in both x and y directions. This change is animated
     */
    func animateToScale(_ scale: CGFloat = 1.0)
    {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        animate
        {
            $0.transform = transform
        }
    }
    
    /**
     Restores a view's scale back to normal by applying the .identity
     Transformation Matrix.
     */
    func restoreScale()
    {
        animate
        {
            $0.transform = CGAffineTransform.identity
        }
    }
    
    func animateLayoutChange(duration: TimeInterval = 0.3)
    {
        self.animate(duration: duration, effect: .curveEaseInOut)
        {
            $0.layoutIfNeeded()
        }
    }
    
    func animate(duration: TimeInterval = 0.4, effect: UIView.AnimationOptions = .curveEaseOut, _ animations: @escaping (Self) -> ())
    {
        let wrapper =
        {
            animations(self)
        }
        
        UIView.transition(with: self, duration: duration, options: effect, animations: wrapper, completion: nil)
    }
    
}

//======================================
//MARK: CAPTURING SCREENSHOTS
//======================================
public extension UIView
{
    
    /**
     Takes a screenshot of the UIView without a loss in quality.
     This is useful for sharing specialized views as images,
     or for allowing the user to share a specific portion of
     a UIView.
     */
    func capture() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext()
            else
        {
            UIGraphicsEndImageContext()
            return nil
        }
        
        layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}


//======================================
//MARK: BUTTONS
//======================================

public extension UIButton
{
    
    func disable()
    {
        isEnabled = false
    }
    
    func enable()
    {
        isEnabled = true
    }
    
    func hideTitle()
    {
        self.setTitle(nil, for: .normal)
    }
    
}

public extension UIBarButtonItem
{
    
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for states: [UIControl.State])
    {
        states.forEach
            {
                setTitleTextAttributes(attributes, for: $0)
        }
    }
    
    func enable()
    {
        isEnabled = true
    }
    
    func disable()
    {
        isEnabled = false
    }
    
}


//======================================
// MARK: WIGGLE ANIMATION
//======================================
public extension UIView
{
    
    func startWiggling()
    {
        addWigglingAnimationToCell()
    }
    
    func stopWiggling()
    {
        removeWigglingAnimationFromCell()
    }
    
    private func addWigglingAnimationToCell()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        layer.add(createRotationAnimation(), forKey: "rotation")
        layer.add(createBounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }
    
    private func removeWigglingAnimationFromCell()
    {
        layer.removeAllAnimations()
    }
    
    private func createRotationAnimation() -> CAKeyframeAnimation
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        
        let angle: CGFloat = 0.005
        let duration: TimeInterval = 0.1
        let variance = 0.025
        
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = randomizeInterval(interval: duration, withVariance: variance)
        animation.repeatCount = .infinity
        
        return animation
    }
    
    private func createBounceAnimation() -> CAKeyframeAnimation
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce: CGFloat = 0.5
        let duration: TimeInterval = 0.12
        let variance = 0.025
        
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = randomizeInterval(interval: duration, withVariance: variance)
        animation.repeatCount = .infinity
        
        return animation
    }
    
    private func randomizeInterval(interval: TimeInterval, withVariance variance: Double) -> TimeInterval
    {
        let random = Double(arc4random_uniform(1000)) / 1000.0
        return interval + (variance * random)
    }
    
}


//======================================
// MARK: CLEANUP
//======================================
public extension UIView
{
    
    func removeAllGestureRecognizers()
    {
        guard let gestures = self.gestureRecognizers else { return }
        gestures.forEach { self.removeGestureRecognizer($0) }
    }
    
}



//======================================
// MARK: PICKER VIEWS
//======================================

public extension UIPickerView
{
    
    func setSeparatorColor(_ color: UIColor)
    {
        subviews.filter { $0.bounds.height <= 1 }
                .forEach { $0.backgroundColor = color }
    }
    
}


//======================================
// MARK: SCROLL VIEWS
//======================================
public extension UIScrollView
{
    
    var topPadding: CGFloat
    {
        get
        {
            return contentInset.top
        }
        
        set
        {
            let insets = contentInset
            self.contentInset = UIEdgeInsets(top: newValue, left: insets.left, bottom: insets.bottom, right: insets.right)
        }
    }
    
    var bottomPadding: CGFloat
    {
        get
        {
            return contentInset.bottom
        }
        
        set
        {
            let insets = contentInset
            self.contentInset = UIEdgeInsets(top: insets.top, left: insets.left, bottom: newValue, right: insets.right)
        }
    }
    
    func scrollToTop(animated: Bool = false)
    {
        self.setContentOffset(.zero, animated: animated)
    }
    
}

//======================================
// MARK: TEXT VIEW
//======================================
public extension UITextView
{
    
    /**
     Centers the text within the text-view vertically within the frame
     of the [UITextView].
     */
    func centerTextVertically()
    {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    /**
     Creates an exclusion zone on the top view of the text view,
     around the specified view.
     
     - parameter view - The view to wrap the text around.
     - parameter margin - An additional margin around the image; defaults to `zero`.
     */
    func wrapTextAroundViewAtTopLeft(_ view: UIView, margin: CGSize = .zero)
    {
        let width = view.frame.width
        let viewHeight = view.frame.height
        let viewY = view.frame.origin.y
        let viewEndY = viewY + viewHeight
        let thisY = self.frame.origin.y
        
        if thisY > viewEndY
        {
            // Don't set any exclusion zones if the image is fully above this text
            self.textContainer.exclusionPaths = []
            return
        }
        
        let height = abs(viewEndY - thisY)
        let point = CGPoint(x: 0, y: 0)
        let size = CGSize(width: width + margin.width, height: height + margin.height)
        let box = CGRect(origin: point, size: size)
        let path = UIBezierPath(rect: box)
        
        self.textContainer.exclusionPaths = []
        self.textContainer.exclusionPaths = [path]
    }
    
    /**
     Creates an exclusion zone on the middle of the text view,
     around the specified view.
     
     - parameter view - The view to wrap the text around.
     - parameter margin - An additional margin around the image; defaults to `zero`.
     */
    func wrapTextAroundViewInTheMiddle(_ view: UIView, margin: CGSize = .zero)
    {
        let viewSize = view.frame.size
        let height = viewSize.height
        let width = viewSize.width
        let xPoint: CGFloat = 0
        let viewY = view.frame.origin.y
        let thisY = self.frame.origin.y
        let deltaY = viewY - thisY
        let yPoint = deltaY - (margin.height / 2)
        let point = CGPoint(x: xPoint, y: yPoint)
        let size = CGSize(width: width + margin.width, height: height + (margin.height))
        let box = CGRect(origin: point, size: size)
        let path = UIBezierPath(rect: box)
        
        self.textContainer.exclusionPaths = []
        self.textContainer.exclusionPaths = [path]
    }
    
}
