//
//  AlchemyTextView.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 11/26/19.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class AlchemyTextView: UITextView
{
    //======================================
    // MARK: IBInspectable properties
    //======================================
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0
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
    public var placeholderText: String = ""
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var placeholderColor: UIColor = UIColor.lightGray
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var paddingBottom: CGFloat = defaultPadding.bottom
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    var paddingLeft: CGFloat = defaultPadding.left
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var paddingTop: CGFloat = defaultPadding.top
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var paddingRight: CGFloat = defaultPadding.right
    {
        didSet
        {
            updateView()
        }
    }
    
    @IBInspectable
    public var lineFragmentPadding: CGFloat = defaultLineFragmentPadding
    {
        didSet
        {
            updateView()
        }
    }
    
    //======================================
    // MARK: Public APIs
    //======================================
    
    public typealias TextChangeCallback = (_ textView: AlchemyTextView, _ textBefore: String, _ textAfter: String, _ changedText: String) -> (Bool)
    
    public var onTextChanged: TextChangeCallback? = nil
    public var currentNumberOfLines: Int
    {
        guard let font = font else { return 1 }
        return Int(contentSize.height / font.lineHeight)
    }
    
    override public var text: String!
    {
        didSet
        {
            adjustPlaceholder()
            delegate?.textViewDidChange?(self)
        }
    }
    
    override public var attributedText: NSAttributedString!
    {
        didSet
        {
            adjustPlaceholder()
            delegate?.textViewDidChange?(self)
        }
    }
    
    /// In order for this text view to work properly, it must be set as the text delegate.
    /// This override prevents an accidental un-setting of `self` as the text view delegate.
    override public var delegate: UITextViewDelegate?
    {
        get { return self }
        
        set
        {
            if newValue !== self
            {
                super.delegate = self
            }
        }
    }
    
    override public func prepareForInterfaceBuilder()
    {
        updateView()
    }
    
    //======================================
    // MARK: Private Functionality
    //======================================
    
    //Used to access default properties, to overcome Swift's lame initializers
    private static let dummyTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private static let defaultPadding: UIEdgeInsets = dummyTextView.textContainerInset
    private static let defaultLineFragmentPadding = dummyTextView.textContainer.lineFragmentPadding
    
    private let placeholderLabel = UILabel()
    private let placeholderTag = 100
    
}

//======================================
// MARK: PREPARING THE UI
//======================================
private extension AlchemyTextView
{
    
    func updateView()
    {
        preparePadding()
        prepareLayer()
        preparePlaceholder()
    }
    
    private func preparePadding()
    {
        let top = paddingTop
        let left = paddingLeft
        let bottom = paddingBottom
        let right = paddingRight
        
        let inset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        textContainerInset = inset
        textContainer.lineFragmentPadding = lineFragmentPadding
    }
    
    private func prepareLayer()
    {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    private func preparePlaceholder()
    {
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = self.font
        placeholderLabel.tag = placeholderTag
        
        if (self.viewWithTag(placeholderTag) as? UILabel) != nil
        {
            
        }
        else
        {
            self.delegate = self
            self.addSubview(placeholderLabel)
        }
        
        resizePlaceholder()
        adjustPlaceholder()
    }
    
    private func adjustPlaceholder()
    {
        self.placeholderLabel.isVisible = text?.isEmpty ?? true
    }
    
    private func resizePlaceholder()
    {
        let labelX = paddingLeft + self.textContainer.lineFragmentPadding
        let labelY = paddingTop
        let labelWidth = self.frame.width - (labelX * 2)
        let labelHeight = placeholderLabel.frame.height
        
        placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        placeholderLabel.sizeToFit()
        
    }
}

//======================================
// MARK: Text View Delegate
//======================================
extension AlchemyTextView: UITextViewDelegate
{
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let changedText = text
        let oldText = textView.text ?? ""
        let newText = oldText.replacingText(inRage: range, with: changedText)
        
        return onTextChanged?(self, oldText, newText, changedText) ?? true
    }
    
    public func textViewDidChange(_ textView: UITextView)
    {
        self.placeholderLabel.isVisible = text.isEmpty
    }
}

//=========================================
//MARK: String Extension
//=========================================
extension String
{
    func replacingText(inRage range: NSRange, with replacement: String) -> String
    {
        let oldText = self as NSString
        return oldText.replacingCharacters(in: range, with: replacement)
    }
    
    func trimmingWhiteSpace() -> String
    {
        if self.contains(" ")
        {
            let trimmedString = self.replacingOccurrences(of: " ", with: "")
            return trimmedString
        }
        
        return self
    }
}
