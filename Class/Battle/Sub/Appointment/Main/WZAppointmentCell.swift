//
//  WZAppointmentCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAppointmentCell: UITableViewCell {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    var model: WZAppointmentModel? {
        didSet {
            if let sponsorHeadImageFile = model?.sponsor?.object(forKey: "headImage") as? AVFile, let headImageUrl = sponsorHeadImageFile.url() {
                headImageView.sd_setImage(with: URL.init(string: headImageUrl), placeholderImage: UIImage.defaultHeadImage)
            }
            nameLabel.text = model?.sponsor?.username
            clubNameLabel.text = model?.venueModel?.clubName
            dateLabel.text = KFTDateTool.string(from: model?.date ?? Date.init(), dateFormat: "yyyy.MM.dd HH:mm")
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
