//
//  DHSocialCommentCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/4/11.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

class WZSocialCommentCell: UITableViewCell {

    /** 头像 */
    @IBOutlet weak var headerImageView: UIImageView!
    /** 姓名 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 日期 */
    @IBOutlet weak var dateLabel: UILabel!
    /** 内容 */
    @IBOutlet weak var contentLabel: UILabel!
    
    var model: WZCommentModel? {
        didSet {
            if let model = self.model {
                if let user = model.user {
                    if let headImgFile = user.object(forKey: "headImage") as? AVFile, let url = headImgFile.url() {
                        self.headerImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
                    }
                    self.nameLabel.text = user.username
                }
                self.dateLabel.text = model.date
                self.contentLabel.text = model.content
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
