//
//  AlchemyButton.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 7/10/19.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
public class AlchemyButton: UIButton
{
    
    typealias Callback = (AlchemyButton) -> Void
    var onTap: Callback?
    
    override public var bounds: CGRect
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var scaleEffect: Bool = false
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var scaleFactor: CGFloat = 1.0
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var animationDuration: Double = 0.2
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var circular: Bool = false
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat  = 0
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear
    {
        
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var imageOnTheRight: Bool = false
    {
        didSet
        {
            updateView()
        }
        
    }
    
    //MARK: Shadow Code
    
    @IBInspectable
    public var shadowColor: UIColor = UIColor.clear
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var shadowOpacity: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var shadowOffset: CGSize = CGSize.zero
    {
        didSet
        {
            updateView()
        }
        
    }
    
    @IBInspectable
    public var kerning: Double = 0
    {
        didSet
        {
            updateView()
        }
        
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize()
    {
        addButtonListener()
    }
    
    
}

//=========================================
//MARK: SETUP CODE
//=========================================
extension AlchemyButton
{
    
    override public func prepareForInterfaceBuilder()
    {
        updateView()
    }
    
    private func updateView()
    {
        adjustBorder()
        adjustShadow()
        adjustKerning()
        adjustScaling()
        adjustIconPositioning()
    }
    
    private func adjustBorder()
    {
        if circular
        {
            let cornerRadius = max(frame.width, frame.height) / 2
            layer.cornerRadius = cornerRadius
        }
        else
        {
            layer.cornerRadius = cornerRadius
        }
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    private func adjustShadow()
    {
        //Shadow
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    private func adjustKerning()
    {
        //Kerning
        if let label = titleLabel, kerning > 0
        {
            
            var adjustedText: NSMutableAttributedString
            
            if let attributedText = label.attributedText
            {
                adjustedText = NSMutableAttributedString(attributedString: attributedText)
            }
            else if let text = label.text
            {
                adjustedText = NSMutableAttributedString(string: text)
            }
            else
            {
                adjustedText = NSMutableAttributedString(string: "")
            }
            
            let range = NSMakeRange(0, adjustedText.length)
            adjustedText.addAttribute(NSAttributedString.Key.kern, value: NSNumber(value: kerning), range: range)
            
            label.attributedText = adjustedText
        }
    }
    
    private func adjustScaling()
    {
        //Scaling
        scaleEffect ? registerTouchEffects() : unregisterTouchEffects()
    }
    
    private func adjustIconPositioning()
    {
        semanticContentAttribute = imageOnTheRight ? .forceRightToLeft : .forceLeftToRight
    }
    
    private func registerTouchEffects()
    {
        self.addTarget(self, action: #selector(highlight), for: .touchDown)
        self.addTarget(self, action: #selector(unhighlight), for: .touchUpInside)
        self.addTarget(self, action: #selector(unhighlight), for: .touchUpOutside)
        self.addTarget(self, action: #selector(unhighlight), for: .touchCancel)
    }
    
    private func unregisterTouchEffects()
    {
        self.removeTarget(self, action: #selector(highlight), for: .touchDown)
        self.removeTarget(self, action: #selector(unhighlight), for: .touchUpInside)
        self.removeTarget(self, action: #selector(unhighlight), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(unhighlight), for: .touchCancel)
    }
    
    @objc func highlight()
    {
        
        let transformation = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        animate(duration: animationDuration)
        { _ in
            self.transform = transformation
        }
    }
    
    @objc func unhighlight()
    {
        animate
        { _ in
            self.transform = CGAffineTransform.identity
        }
    }
}


//=========================================
//MARK: APIs
//=========================================
extension AlchemyButton
{
    
    static func create(forView view: UIView, title: String, fontSize: CGFloat = 30, buttonColor: UIColor = .blue, textColor: UIColor = .white) -> AlchemyButton
    {
        let button = AlchemyButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        button.backgroundColor = buttonColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        
        return button
    }
    
    func attach(toTextField textField: UITextField, onTap callback: Callback? = nil)
    {
        textField.inputAccessoryView = self
        onTap = callback ?? onTap
    }
    
}

//=========================================
//MARK: USER INTERACTIONS
//=========================================
extension AlchemyButton
{
    
    func addButtonListener()
    {
        self.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapButton(_ sender: Any)
    {
        onTap?(self)
    }
    
}

