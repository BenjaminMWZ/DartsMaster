//
//  WZRoundCornerButton.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZRoundCornerButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
    }
}
