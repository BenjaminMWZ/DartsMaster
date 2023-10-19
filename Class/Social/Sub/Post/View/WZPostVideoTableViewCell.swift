//
//  WZPostVideoTableViewCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/30.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

class WZPostVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    var assetModel: WZPostAssetModel? {
        didSet {
            if let model = assetModel {
                self.coverImageView.image = model.videoCoverImage
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
