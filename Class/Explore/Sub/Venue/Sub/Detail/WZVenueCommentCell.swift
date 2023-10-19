//
//  WZVenueCommentCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZVenueCommentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var model: WZEvaluationModel? {
        didSet {
            if let model = self.model {
                if let user = model.user {
                    if let headImgFile = user.object(forKey: "headImage") as? AVFile, let url = headImgFile.url() {
                        self.headImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
                    }
                    nameLabel.text = user.username
                }
                contentLabel.text = model.content
                dateLabel.text = KFTDateTool.string(from: model.createdAt ?? Date.init(), dateFormat: "yyyy.MM.dd HH:mm")
                collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: -----------------  UICollectionViewDataSource -----------------

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZDartsStarItemCell", for: indexPath) as! WZDartsStarItemCell
        if indexPath.item < self.model?.starCount ?? 0 {
            cell.imageView.image = UIImage.init(named: "icon_star")
        } else {
            cell.imageView.image = UIImage.init(named: "icon_star_grey")
        }
        return cell
    }
}
