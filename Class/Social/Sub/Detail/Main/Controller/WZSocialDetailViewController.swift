//
//  WZSocialDetailViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import SVProgressHUD

let kSeguePushAddComment = "ShowWZAddCommentViewController"

class WZSocialDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var model: WZSocialModel?
    var commentModels = [WZCommentModel].init()
    var pageNum = 0
    var videoPlayer: WTVideoPlayerViewController?
    var callBack: ((WZSocialModel?)->())?
    let query = AVQuery.init(className: "Comment")

    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if callBack != nil {
            callBack!(self.model)
        }
    }
    
    func customTableView() {
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.fetchComments(pageNo: self.pageNum)
        })
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.beginRefreshing()
    }
    
    // 获取帖子评论列表
    func fetchComments(pageNo: Int) {
        if let model = self.model {
            query.includeKey("user")
            query.limit = kPageSize
            query.skip = kPageSize * pageNo
            query.cachePolicy = .networkElseCache
            query.addDescendingOrder("createdAt")
            if let postId = model.postId {
                let post = AVObject.init(className: "Post", objectId: postId)
                query.whereKey("post", equalTo: post)
            }
            query.findObjectsInBackground { (results, error) in
                self.tableView.mj_footer?.endRefreshing()
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                } else {
                    self.pageNum += 1
                    if let comments = results as? [AVObject] {
                        self.tableView.mj_footer?.endRefreshing()
                        if comments.count < kPageSize {
                            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                        } else {
                            self.tableView.mj_footer?.resetNoMoreData()
                        }
                        if comments.count > 0 {
                            for item in comments {
                                let commentModel = WZCommentModel.init(commentObject: item)
                                self.commentModels.append(commentModel)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: -- UITableViewDelegate --

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.model?.postType == .video {
                if let videoUrl = self.model?.videoFiles?.url() {
                    if self.videoPlayer == nil {
                        self.videoPlayer = WTVideoPlayerViewController.init()
                    }
                    self.videoPlayer?.videoUrl = URL.init(string: videoUrl)
                    self.navigationController?.present(self.videoPlayer!, animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "视频资源出错, 暂不能播放")
                }
            }
        }
    }
    
    // MARK: -- UITableViewDataSource --

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (self.model != nil) ? 1 : 0
        } else {
            return self.commentModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let postType = self.model?.postType ?? .text
            switch postType {
            case .text:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialTextCell", for: indexPath) as! WZSocialTextCell
                cell.model = self.model
                return cell
            case .imageText:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialImageCell", for: indexPath) as! WZSocialImageCell
                cell.model = self.model
                return cell
            case .video:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialVideoCell", for: indexPath) as! WZSocialVideoCell
                cell.model = self.model
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialCommentCell", for: indexPath) as! WZSocialCommentCell
            cell.model = self.commentModels[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: -- Event Response --

    // MARK: - 举报
    @IBAction func reportBarButtonAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController.init(title: "温馨提示", message: "确定要举报该内容吗？", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "举报", style: .destructive) { (action) in
            SVProgressHUD.show(withStatus: "提交中...")
            if let postId = self.model?.postId {
                let post = AVObject.init(className: "Post", objectId: postId)
                post.incrementKey("reportCount", byAmount: 1)
                post.saveInBackground { (success, error) in
                    SVProgressHUD.showSuccess(withStatus: "举报成功,管理员将在24小时内对此内容采取措施")
                }
            }
        }
        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /** 添加评论 */
    @IBAction func addComment(_ sender: Any) {
        self.performSegue(withIdentifier: kSeguePushAddComment, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSeguePushAddComment {
            let addCommentVC = segue.destination as! WZAddCommentViewController
            addCommentVC.model = self.model
            addCommentVC.callBack = {
                self.model?.commentNumber += 1
                self.query.getFirstObjectInBackground { (object, error) in
                    if object != nil {
                        let model = WZCommentModel.init(commentObject: object!)
                        self.commentModels.insert(model, at: 0)
                        self.tableView.reloadData()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}
