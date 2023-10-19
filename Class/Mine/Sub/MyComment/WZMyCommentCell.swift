//
//  WZMyCommentCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMyCommentCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: WZCommentModel? {
        didSet {
            if let model = model {
                if let postBy = model.postBy {
                    let headImageFile = postBy.object(forKey: "headImage") as? AVFile
                    headImageView.wz_setImage(urlString: headImageFile?.url(), placeHolderImage: UIImage.defaultHeadImage)
                    nameLabel.text = postBy.username
                }
                contentLabel.text = model.content
                dateLabel.text = model.date
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
