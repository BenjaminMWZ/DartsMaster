//
//  WZSocialVideoCell.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZSocialVideoCell: UITableViewCell {
    /** 头像 */
    @IBOutlet weak var headerImageView: UIImageView!
    /** 名字 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 日期 */
    @IBOutlet weak var dateLabel: UILabel!
    /** 内容 */
    @IBOutlet weak var contentLabel: UILabel!
    /** 图片 */
    @IBOutlet weak var coverImageView: UIImageView!
    /** 收藏 */
    @IBOutlet weak var collectButton: UIButton!
    /** 评论 */
    @IBOutlet weak var commentButton: UIButton!
    /** 点赞 */
    @IBOutlet weak var likeButton: UIButton!
    
    var model: WZSocialModel? {
        didSet {
            if let model = self.model {
                if let user = model.postBy {
                    if let headImgFile = user.object(forKey: "headImage") as? AVFile, let url = headImgFile.url() {
                        self.headerImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
                    }
                    self.nameLabel.text = user.username
                }
                
                if let videoCoverImageUrl = model.coverImageFile?.url() {
                    self.coverImageView.sd_setImage(with: URL.init(string: videoCoverImageUrl))
                }
                
                self.dateLabel.text = model.creatDate
                self.contentLabel.text = model.content
                self.collectButton.setTitle("\(model.collectNumber)", for: .normal)
                self.collectButton.setTitle("\(model.collectNumber)", for: .selected)
                self.commentButton.setTitle("\(model.commentNumber)", for: .normal)
                self.likeButton.setTitle("\(model.likeNumber)", for: .normal)
                self.collectButton.isSelected = model.collected
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headerImageView.backgroundColor = nil
    }
    
    /** 收藏 */
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
