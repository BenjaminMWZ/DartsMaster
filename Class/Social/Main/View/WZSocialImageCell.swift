//
//  WZSocialImageCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
//import TZImagePickerController
import QMUIKit

class WZSocialImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /** 头像 */
    @IBOutlet weak var headerImageView: UIImageView!
    /** 名字 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 日期 */
    @IBOutlet weak var dateLabel: UILabel!
    /** 内容 */
    @IBOutlet weak var contentLabel: UILabel!
    /** 图片 */
    @IBOutlet weak var collectionView: UICollectionView!
    /** 收藏 */
    @IBOutlet weak var collectButton: UIButton!
    /** 评论 */
    @IBOutlet weak var commentButton: UIButton!
    /** 点赞 */
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    // 一行显示的图片个数
    let rowCount: CGFloat = 3.0
    
    var model: WZSocialModel? {
        didSet {
            if let model = self.model {
                if let user = model.postBy {
                    if let headImgFile = user.object(forKey: "headImage") as? AVFile, let url = headImgFile.url() {
                        self.headerImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
                    }
                    self.nameLabel.text = user.username
                }
                self.dateLabel.text = model.creatDate
                self.contentLabel.text = model.content
                self.collectButton.setTitle("\(model.collectNumber)", for: .normal)
                self.collectButton.setTitle("\(model.collectNumber)", for: .selected)
                self.commentButton.setTitle("\(model.commentNumber)", for: .normal)
                self.likeButton.setTitle("\(model.likeNumber)", for: .normal)
                self.collectButton.isSelected = model.collected
                self.caculateCollectionViewHeight()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headerImageView.backgroundColor = nil
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        customCollectionView()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 如果不可以交互 | 隐藏 | 透明度太小 3者任意一个都忽略不能点击
        if(!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
            return nil
        }
        let view = super.hitTest(point, with: event)
        if (view?.isKind(of: UICollectionView.classForCoder()) == true) {
            return self
        }
        return view
    }
    
    func customCollectionView() {
        let itemSpacing: CGFloat = 5
        self.layout.minimumInteritemSpacing = 0
        self.layout.minimumLineSpacing = 5
        let width = (UIScreen.main.bounds.size.width - 2 * collectionView.frame.origin.x - (self.rowCount - 1)*itemSpacing)/self.rowCount
        let size = CGSize.init(width: width, height: width)
        self.layout.itemSize = size
    }
    
    func caculateCollectionViewHeight() {
        let width = self.layout.itemSize.width
        // 图片行数
        let rows = CGFloat(min(3, ceil(CGFloat(self.model?.photosUrl.count ?? 0)/rowCount)))
        let totalHeight = rows * width + (rows - 1) * self.layout.minimumLineSpacing
        self.collectionViewHeight.constant = totalHeight
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZImageItemCell", for: indexPath) as! WZImageItemCell
        if let imageUrl = self.model?.photosUrl[indexPath.item] {
            cell.imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage.init(named: "icon_placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var photos: [GKPhoto] = []
        if let urls = self.model?.photosUrl {
            for url in urls {
                let photo = GKPhoto.init()
                photo.url = url
                photos.append(photo)
            }
        }
        let browser = GKPhotoBrowser.init(photos: photos, currentIndex: indexPath.item)
        browser.modalPresentationStyle = .fullScreen
        browser.show(fromVC: (UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.photosUrl.count ?? 0
    }
    
    @IBAction func collectButtonAction(_ sender: UIButton) {
        if let model = self.model, let objectId = model.postId {
            let post = AVObject.init(className: "Post", objectId: objectId)
            if self.collectButton.isSelected {
                // 取消收藏
                model.collectNumber -= 1
                post.incrementKey("collectNumber", byAmount: -1)
                self.collectButton.setTitle("\(model.collectNumber)", for: .normal)
                let query = AVQuery.init(className: "Collect")
                query.whereKey("post", equalTo: post)
                query.whereKey("user", equalTo: AVUser.current() as Any)
                query.getFirstObjectInBackground { (objc, error) in
                    objc?.deleteInBackground()
                    SVProgressHUD.showSuccess(withStatus: "取消收藏".localizedString())
                }
            } else {
                // 收藏
                // 收藏数加1
                model.collectNumber += 1
                post.incrementKey("collectNumber", byAmount: 1)
                self.collectButton.setTitle("\(model.collectNumber)", for: .selected)
                let collectObjc = AVObject.init(className: "Collect")
                collectObjc.setObject(post, forKey: "post")
                collectObjc.setObject(AVUser.current(), forKey: "user")
                collectObjc.saveInBackground()
                SVProgressHUD.showSuccess(withStatus: "已收藏".localizedString())
            }
            self.collectButton.isSelected = !self.collectButton.isSelected
            // 更新云端数据
            post.saveInBackground()
        }
    }
    
    /** 点赞 */
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if let model = self.model, let objectId = model.postId {
            // 点赞数加1
            model.likeNumber += 1
            self.likeButton.setTitle("\(model.likeNumber)", for: .normal)
            let post = AVObject.init(className: "Post", objectId: objectId)
            post.incrementKey("likeNumber", byAmount: 1)
            // 更新云端数据
            post.saveInBackground()
        }
    }
}
