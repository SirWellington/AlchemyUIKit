//
//  AlchemyView.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class AlchemyView: UIView
{
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override public func prepareForInterfaceBuilder()
    {
        updateView()
    }
    
    @IBInspectable public var circular: Bool = false
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var borderThickness: CGFloat = 0
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.black
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var shouldRasterize: Bool = false
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 3, height: 0)
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = .fromRGBA(red: 0, green: 0, blue: 0, alpha: 50)
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable public var shadowBlur: CGFloat = 4
    {
        didSet
        {
            updateView()
        }
    }
    
    private func updateView()
    {
        if circular
        {
            let radius = self.frame.width / 2
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
        else
        {
            layer.cornerRadius = cornerRadius
        }
        
        layer.borderWidth = borderThickness
        layer.borderColor = borderColor.cgColor
        layer.shouldRasterize = shouldRasterize
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        
        
        if shouldRasterize
        {
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        updateView()
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        updateView()
    }
    
    
}
