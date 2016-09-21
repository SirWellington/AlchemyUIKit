//
//  Color.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2016 Sir Wellington. All rights reserved.
//

import Foundation
import UIKit


internal class Colors
{
    
    static let PRIMARY: UIColor = Colors.fromRGB(red: 251, green: 62, blue: 60)
    static let ACCENT: UIColor = Colors.fromRGB(red: 27, green: 32, blue: 33)
    static let ALTERNATIVE_ACCENT: UIColor = Colors.fromRGB(red: 166, green: 118, blue: 100)
    
    static let BLACK = Colors.fromRGB(red: 0, green: 0, blue: 0)
    static let BLUE = Colors.fromRGB(red: 3, green: 122, blue: 255)
    static let GREEN = Colors.fromRGB(red: 0, green: 166, blue: 118)
    static let MAROON = Colors.fromRGB(red: 100, green: 6, blue: 17)
    static let PINK = Colors.fromRGB(red: 255, green: 0, blue: 122)
    static let TURQUOISE = Colors.fromRGB(red: 10, green: 175, blue: 190)
    static let YELLOW = Colors.fromRGB(red: 248, green: 231, blue: 28)
    static let MID_GRAY = Colors.fromRGB(red: 74, green: 74, blue: 74)
    static let LIGHT_GRAY = Colors.fromRGB(red: 233, green: 233, blue: 233)
    static let WHITE = Colors.fromRGB(red: 255, green: 255, blue: 255)
    
    
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return fromRGBA(red: red, green: green, blue: blue, alpha: 100)
    }
    
    static func fromRGBA(red: CGFloat, green: CGFloat, blue:CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/100)
    }
    
    
}
