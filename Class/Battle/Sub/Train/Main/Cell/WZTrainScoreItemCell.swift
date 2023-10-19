//
//  WZTrainScoreItemCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/24.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTrainScoreItemCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
    }
}
