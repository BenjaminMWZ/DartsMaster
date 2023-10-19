//
//  WZTutorialModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/12.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTutorialModel: NSObject {
    var title: String?
    var content: String?
    
    init(dict: Dictionary<String, String>) {
        super.init()
        title = dict["title"]
        content = dict["content"]
    }
}
