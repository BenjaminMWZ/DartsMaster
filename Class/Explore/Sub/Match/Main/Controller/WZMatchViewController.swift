//
//  WZMatchViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/4.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMatchViewController: WZTableViewController {

    var pageNumber = 0
    var matchModels: [WZMatchModel] = []
    let query = AVQuery.init(className: "Match")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.tableView.mj_footer?.isHidden = true
            self.pageNumber = 0
            self.loadData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.tableView.mj_header?.isHidden = true
            self.pageNumber += 1
            self.loadData()
        })
        self.tableView.mj_header?.beginRefreshing()
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
    }

    func loadData() {
        query.addDescendingOrder("createdAt")
        query.skip = pageNumber * kPageSize
        query.limit = kPageSize
        query.cachePolicy = .networkElseCache
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
                        self.matchModels.removeAll()
                    }
                    if data.count > 0 {
                        for obj in data {
                            let postModel = WZMatchModel.init(object: obj)
                            self.matchModels.append(postModel)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZMatchCell", for: indexPath) as! WZMatchCell
        cell.model = matchModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWZWebDetailViewController", sender: matchModels[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZWebDetailViewController" {
            let detailController = segue.destination as! WZWebDetailViewController
            let model = sender as? WZMatchModel
            detailController.title = model?.title
            detailController.urlString = model?.detailUrl
        }
    }
}
