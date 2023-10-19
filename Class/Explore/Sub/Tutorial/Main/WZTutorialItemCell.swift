//
//  WZTutorialItemCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/12.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTutorialItemCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var tutorialModel: WZTutorialModel? {
        didSet {
            if let model = tutorialModel {
                self.titleLabel.text = model.title
                self.contentLabel.text = model.content
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.init(hexString: "C4C4C6").cgColor
    }
}
