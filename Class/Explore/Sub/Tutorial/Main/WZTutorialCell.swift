//
//  WZTutorialCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/12.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

@objc
protocol WZTutorialCellDelegate {
    func tutorialCellDidSelectItem(_ itemModel: WZTutorialModel?)
}

class WZTutorialCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: WZTutorialCellDelegate?
    var tutorials: [WZTutorialModel]? {
        didSet {
            if let data = self.tutorials {
                if data.count > 0 {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // MARK: -- UICollectionViewDataSource --
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.tutorials?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZTutorialItemCell", for: indexPath) as! WZTutorialItemCell
        cell.tutorialModel = self.tutorials?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.tutorialCellDidSelectItem(self.tutorials?[indexPath.item])
        }
    }
}
