//
//  WZMyCommentViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMyCommentViewController: WZTableViewController {

    var pageNumber = 0
    var commentModels: [WZCommentModel] = []
    lazy var query: AVQuery = {
        let query = AVQuery.init(className: "Comment")
        query.addDescendingOrder("createdAt")
        query.includeKey("postBy.headImage")
        query.includeKey("postBy.username")
        query.limit = kPageSize
        return query
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    
    func customUI() {
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.pageNumber = 0
            self.tableView.mj_footer?.isHidden = true
            self.loadData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNumber += 1
            self.tableView.mj_header?.isHidden = false
            self.loadData()
        })
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func loadData() {
        query.skip = kPageSize * pageNumber
        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.isHidden = false
            self.tableView.mj_footer?.isHidden = false
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if error != nil {
                SVProgressHUD.show(withStatus: error?.localizedDescription)
            } else {
                if let data = result as? [AVObject] {
                    if data.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if self.pageNumber == 0 {
                        self.commentModels.removeAll()
                    }
                    if data.count > 0 {
                        for obj in data {
                            let model = WZCommentModel.init(commentObject: obj)
                            self.commentModels.append(model)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZMyCommentCell", for: indexPath) as! WZMyCommentCell
        cell.model = commentModels[indexPath.row]
        return cell
    }
}
