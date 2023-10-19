//
//  WZVenueCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZVenueCell: UITableViewCell {

    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    
    var model: WZVenueModel? {
        didSet {
            if let model = self.model {
                self.titleLabel.text = model.clubName
                self.addressLabel.text = model.address
                if let imageUrl = model.imageUrls?.first {
                    self.coverImgView.sd_setImage(with: URL.init(string: imageUrl))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
