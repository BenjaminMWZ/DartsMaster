//
//  WZTrainPlayerCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import LTMorphingLabel

class WZTrainPlayerCell: UICollectionViewCell {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: LTMorphingLabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var player: WZPlayer? {
        didSet {
            self.playerNameLabel.text = player?.name
            self.playerScoreLabel.text = "\(player?.score ?? 0)"
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = UIColor.themeColor
                self.playerNameLabel.textColor = UIColor.white
                self.playerNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                self.playerScoreLabel.textColor = UIColor.white
                self.playerScoreLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
            } else {
                self.contentView.backgroundColor = UIColor.white
                self.playerNameLabel.textColor = UIColor.init(hexString: "333333")
                self.playerNameLabel.font = UIFont.systemFont(ofSize: 18)
                self.playerScoreLabel.textColor = UIColor.black
                self.playerScoreLabel.font = UIFont.systemFont(ofSize: 36)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.init(hexString: "CCCCCC")?.cgColor
        self.playerScoreLabel.morphingEffect = .sparkle
    }
}
