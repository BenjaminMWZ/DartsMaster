//
//  WZDartsViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/4.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZDartsViewController: WZTableViewController {

    var pageNumber: Int = 0
    var dartModels: [WZDartsModel] = []
    let query = AVQuery.init(className: "Dart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
    }
    
    func customUI() {
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
        query.limit = kPageSize
        query.skip = kPageSize * self.pageNumber
        query.addDescendingOrder("createdAt")
        query.cachePolicy = .networkElseCache

        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.isHidden = false
            self.tableView.mj_footer?.isHidden = false
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if error != nil {
                SVProgressHUD.show(withStatus: error?.localizedDescription)
            } else {
                if let darts = result as? [AVObject] {
                    if darts.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if self.pageNumber == 0 {
                        self.dartModels.removeAll()
                    }
                    if darts.count > 0 {
                        for object in darts {
                            let postModel = WZDartsModel.init(object: object)
                            self.dartModels.append(postModel)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dartModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZDartsCell", for: indexPath) as! WZDartsCell
        cell.model = self.dartModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showWZDartsDetailViewController", sender: self.dartModels[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWZDartsDetailViewController" {
            let model = sender as? WZDartsModel
            let detailVC = segue.destination as? WZDartsDetailViewController
            detailVC?.model = model
        }
    }
}
