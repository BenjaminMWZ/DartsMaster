//
//  WZAcceptUserCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAcceptUserCell: UICollectionViewCell {
    @IBOutlet var headImageView: UIImageView!
    
    var user: AVUser? {
        didSet {
            if let user = user, let userHeadImageFile = user.object(forKey: "headImage") as? AVFile, let imageUrl = userHeadImageFile.url() {
                headImageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: UIImage.init(named: "icon_headImge"))
            }
        }
    }
}
