//
//  WZSearchViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/20.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

let kShowDetailSgue = "ShowWZSocialDetailViewController"

class WZSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchKey = ""
    var pageNumer = 0
    
    lazy var userQuery: AVQuery = {
        let query = AVUser.query()
        return query
    }()
    
    var socialModels: [WZSocialModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
//        self.searchBar.showsCancelButton = true
//        self.searchBar.showsSearchResultsButton
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [unowned self] in
            self.pageNumer += 1
            self.searchData(searchKey: self.searchKey)
        })
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
    }
    
    func searchData(searchKey: String) {
        userQuery.whereKey("username", contains: searchKey)
        userQuery.findObjectsInBackground { [unowned self] (result, error) in
            var subQueries: [AVQuery] = []
            if let users = result {
                let containUserPostQuery = AVQuery.init(className: "Post")
                containUserPostQuery.whereKey("postBy", containedIn: users)
                subQueries.append(containUserPostQuery)
            }
            let containContentQuery = AVQuery.init(className: "Post")
            containContentQuery.whereKey("content", contains: searchKey)
            subQueries.append(containContentQuery)
            let orQuery = AVQuery.orQuery(withSubqueries: subQueries)
            orQuery.includeKey("postBy")
            orQuery.includeKey("photos")
            orQuery.includeKey("video")
            orQuery.includeKey("coverImage")
            orQuery.addDescendingOrder("createdAt")
            orQuery.limit = kPageSize
            orQuery.skip = kPageSize * self.pageNumer
            orQuery.findObjectsInBackground { (result, error) in
                self.tableView.mj_footer?.endRefreshing()
                if let err = error {
                    SVProgressHUD.showError(withStatus: err.localizedDescription)
                } else {
                    SVProgressHUD.dismiss()
                    if let data = result as? [AVObject] {
                        if data.count < kPageSize {
                            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                        } else {
                            self.tableView.mj_footer?.resetNoMoreData()
                        }
                        
                        if data.count > 0 {
                            self.searchBar.resignFirstResponder()
                            for obj in data {
                                let model = WZSocialModel.init(postObject: obj)
                                self.socialModels.append(model)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: -- UISearchBarDelegate --

//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("点击取消")
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if NSString.isEmpty(searchBar.text) {
            SVProgressHUD.showError(withStatus: "请输入关键字")
            return
        }
        pageNumer = 0
        socialModels.removeAll()
        tableView.reloadData()
        tableView.mj_footer?.resetNoMoreData()
        searchKey = searchBar.text ?? ""
        SVProgressHUD.show(withStatus: "搜索中...")
        searchData(searchKey: searchKey)
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("结束编辑")
//    }
    
    // MARK: -- UITableViewDelegate --

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            //            cell.collectionViewDidSelectedCallBack = {
            //                self.performSegue(withIdentifier: "PushToSocialDetailViewController", sender: indexPath.row)
            //            }
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialVideoCell", for: indexPath) as! WZSocialVideoCell
            cell.model = model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kShowDetailSgue, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetailSgue {
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
