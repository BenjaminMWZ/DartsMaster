//
//  WZImageItemCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZImageItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.init(hexString: "E6E6E6")
        imageView.contentMode = .scaleAspectFill
    }
}
