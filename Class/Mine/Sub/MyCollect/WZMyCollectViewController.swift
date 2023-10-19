//
//  WZMyCollectViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/31.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMyCollectViewController: WZTableViewController {

    var collectModels: [WZSocialModel] = []
    var pageNumber = 0
    lazy var query: AVQuery = {
        let query = AVQuery.init(className: "Collect")
        query.addDescendingOrder("createdAt")
        query.includeKey("post")
        query.includeKey("coverImage")
        query.includeKey("video")
        query.includeKey("photos")
        query.whereKey("user", equalTo: AVUser.current() as Any)
        query.limit = kPageSize
        return query
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView()
    }
    
    func customTableView() {
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.pageNumber = 0
            self.tableView.mj_footer?.isHidden = true
            self.loadData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNumber += 1
            self.tableView.mj_header?.isHidden = true
            self.loadData()
        })
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func loadData() {
        query.skip = self.pageNumber * kPageSize
         query.cachePolicy = .networkElseCache
        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.isHidden = false
            self.tableView.mj_footer?.isHidden = false
            // 判断下查询到的集合数据内元素个数是否大于0
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_header?.endRefreshing()
            if error == nil {
                if let data = result as? [AVObject] {
                    if data.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if self.pageNumber == 0 {
                        self.collectModels.removeAll()
                    }
                    if data.count > 0 {
                        // 循环遍历 依次取出集合中的每一个元素
                        for obj in data {
                            if let post = obj.object(forKey: "post") as? AVObject {
                                let model = WZSocialModel.init(postObject: post)
                                model.collected = true
                                model.postBy = AVUser.current()
                                self.collectModels.append(model)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                // 有错误
                print("请求数据错误 ===> \(error?.localizedDescription ?? "")/n")
                //                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWZSocialDetailViewController", sender: indexPath.row)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postType = self.collectModels[indexPath.row].postType
        let model = self.collectModels[indexPath.row]
        switch postType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialTextCell", for: indexPath) as! WZSocialTextCell
            cell.model = model
            return cell
        case .imageText:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialImageCell", for: indexPath) as! WZSocialImageCell
            cell.model = model
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialVideoCell", for: indexPath) as! WZSocialVideoCell
            cell.model = model
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZSocialDetailViewController" {
            let detailVC = segue.destination as! WZSocialDetailViewController
            let index = sender as! Int
            detailVC.model = self.collectModels[index]
            detailVC.callBack = { postModel in
                if let model = postModel {
                    self.collectModels[index] = model
                    self.tableView.reloadData()
                }
            }
        }
    }
}
