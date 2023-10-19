
//
//  WZMatchCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMatchCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: WZMatchModel? {
        didSet {
            if let model = self.model {
                if let imageFileUrl = model.coverImage?.url() {
                    coverImageView.sd_setImage(with: URL.init(string: imageFileUrl))
                }
                titleLabel.text = model.title
                sourceLabel.text = (model.source != nil) ? "来源：".localizedString() + "\(model.source!)" : ""
                dateLabel.text = KFTDateTool.string(from: model.createdAt ?? Date.init(), dateFormat: "yyyy.MM.dd HH:mm")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
