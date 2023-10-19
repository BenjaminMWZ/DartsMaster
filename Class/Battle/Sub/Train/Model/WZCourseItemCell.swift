//
//  WZCourseItemCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/23.
//  Copyright © 2020 BenjaminMao. All rights reserved.
//

import UIKit

class WZCourseItemCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // 当 cell 从 storyboard 中加载完成时, 会调用这个函数, 我们可以在这个函数中添加一些初始化的任务
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置边框宽度
        self.contentView.layer.borderWidth = 1
        // 设置边框颜色
        self.contentView.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
    }
}
