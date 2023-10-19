//
//  WZBaseViewController.swift
//  Sailing
//
//  Created by 马冰垒 on 2020/8/9.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

class WZBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
