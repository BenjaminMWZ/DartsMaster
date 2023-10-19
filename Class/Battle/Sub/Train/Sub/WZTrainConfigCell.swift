//
//  WZTrainConfigCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/24.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTrainConfigCell: UITableViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            self.selectedImageView.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
