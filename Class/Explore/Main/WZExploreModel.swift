//
//  WZExploreModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/11.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZExploreModel: NSObject {
    var title: String?
    var iconImage: UIImage?
    var startColor: UIColor?
    var endColor: UIColor?
    
    init(title: String, iconImage: UIImage ,startColor: UIColor, endColor: UIColor) {
        self.title = title
        self.iconImage = iconImage
        self.startColor = startColor
        self.endColor = endColor
    }
}
