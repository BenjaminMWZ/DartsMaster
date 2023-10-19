//
//  WZExploreCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/11.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZExploreCell: UITableViewCell {

    var model: WZExploreModel? {
        didSet {
            if let model = self.model {
                self.backgroundImageView.image = WHGradientHelper.getLinearGradientImage(model.startColor, and: model.endColor, directionType: WHGradientDirection.linearGradientDirectionLevel, option:CGSize.init(width: UIScreen.main.bounds.size.width - 2 * self.backgroundImageView.bounds.origin.x, height: self.backgroundImageView.bounds.size.height))
                self.iconImageView.image = model.iconImage
                self.titleLabel.text = model.title
            }
        }
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
