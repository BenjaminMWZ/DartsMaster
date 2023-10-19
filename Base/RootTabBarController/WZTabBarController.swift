//
//  WZTabBarController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customTabBar()
    }
    
    func customTabBar() {
        self.hidesBottomBarWhenPushed = true
        if let items = self.tabBar.items {
            for item in items {
                item.image = item.image?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
//                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themeColor!], for: .selected)
            }
        }
        self.tabBar.tintColor = UIColor.themeColor
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
