//
//  WZMyPostViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/8/1.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMyPostViewController: WZTableViewController {
    var pageNumber: Int = 0
    var socialModels: [WZSocialModel] = []
    lazy var query: AVQuery = {
        let query = AVQuery.init(className: "Post")
        query.limit = kPageSize
        query.includeKey("postBy")
        query.includeKey("photos")
        query.includeKey("video")
        query.includeKey("coverImage")
        query.addDescendingOrder("createdAt")
        query.whereKey("postBy", equalTo: AVUser.current() as Any)
        query.cachePolicy = .networkElseCache
        return query
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableViewHeaderAndFooter()
    }

    func customTableViewHeaderAndFooter() {
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.pageNumber = 0
            self.tableView.mj_footer?.isHidden = true
            self.requestData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNumber += 1
            self.tableView.mj_header?.isHidden = false
            self.requestData()
        })
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func requestData() {
        query.skip = kPageSize * self.pageNumber

        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.isHidden = false
            self.tableView.mj_footer?.isHidden = false
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if error != nil {
                SVProgressHUD.show(withStatus: error?.localizedDescription)
            } else {
                if let posts = result as? [AVObject] {
                    if posts.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if self.pageNumber == 0 {
                        self.socialModels.removeAll()
                    }
                    if posts.count > 0 {
                        for postObject in posts {
                            let postModel = WZSocialModel.init(postObject: postObject)
                            self.socialModels.append(postModel)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWZSocialDetailViewController", sender: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postType = self.socialModels[indexPath.row].postType
        let model = self.socialModels[indexPath.row]
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
            detailVC.model = self.socialModels[index]
            detailVC.callBack = { postModel in
                if let model = postModel {
                    self.socialModels[index] = model
                    self.tableView.reloadData()
                }
            }
        }
    }
}
