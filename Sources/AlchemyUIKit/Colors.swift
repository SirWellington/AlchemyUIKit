//
//  Color.swift
//  AlchemyUIKit
//
//  Created by Wellington Moreno on 9/20/16.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor
{
    static func fromRGBA(red: CGFloat, green: CGFloat, blue:CGFloat, alpha: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/100)
    }
    
}
