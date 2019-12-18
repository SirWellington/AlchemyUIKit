//
//  ViewController.swift
//  AlchemyUIApp
//
//  Created by Wellington Moreno on 12/18/19.
//  Copyright © 2019 Sir Wellington. All rights reserved.
//

import AlchemyUIKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkmark: AlchemyCheckbox!
    @IBOutlet weak var textView: AlchemyTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Checkmark is [\(checkmark)]")
    }


}

