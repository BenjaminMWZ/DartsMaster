//
//  WZPostImageTableViewCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/12.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit
import TZImagePickerController

class WZPostImageTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    // 一行显示的图片个数
    let rowCount: CGFloat = 3.0
    // 图片的总个数
    var imagesCount = 9
    var assetModel: WZPostAssetModel? {
        didSet {
            if assetModel != nil {
                self.customCollectionView()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.customCollectionView()
    }
    
    func customCollectionView() {
        let itemSpacing: CGFloat = 5;
        self.layout.minimumInteritemSpacing = 0
        self.layout.minimumLineSpacing = 5
        let width = (collectionView.frame.size.width - (self.rowCount - 1)*itemSpacing)/self.rowCount
        let size = CGSize.init(width: width, height: width)
        self.layout.itemSize = size
        // 图片行数
        let rows = CGFloat(min(3, ceil(CGFloat(self.assetModel?.photos?.count ?? Int(rowCount))/rowCount)))
        let totalHeight = rows * width + (rows - 1) * self.layout.minimumLineSpacing
        self.collectionViewHeight.constant = totalHeight
    }
    
    // MARK: -- UICollectionViewDataSource --

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZImageItemCell", for: indexPath) as! WZImageItemCell
        if let photo = self.assetModel?.photos?[indexPath.row] {
            cell.imageView.image = photo
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assets: NSMutableArray =  NSMutableArray.init(array: (self.assetModel?.assets)!)
        let photos: NSMutableArray =  NSMutableArray.init(array: (self.assetModel?.photos)!)
        let imagePreviewController = TZImagePickerController.init(selectedAssets: assets, selectedPhotos: photos, index: indexPath.row)!
        imagePreviewController.title = "图片预览"
        imagePreviewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePreviewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetModel?.photos?.count ?? 0
    }
}
