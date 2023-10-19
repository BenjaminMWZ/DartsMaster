//
//  WZDartsCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZDartsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: WZDartsModel? {
        didSet {
            if let imageUrl = model?.imageUrls?.first {
                coverImageView.sd_setImage(with: URL.init(string: imageUrl))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    // MARK: -- UICollectionViewDataSource --

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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
