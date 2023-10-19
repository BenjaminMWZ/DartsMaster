//
//  WZVenueViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/4.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZVenueViewController: WZTableViewController {
    
    var isSelectedMode: Bool = false
    @IBOutlet weak var selectedButton: UIBarButtonItem!
    var isSelectingVenue: Bool = false
    var selectedIndex: Int = 0
    var selectedVenueCallback: ((WZVenueModel) -> ())?
    let query = AVQuery.init(className: "Venue")
    var venueModels: [WZVenueModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSelectedMode == false {
            self.navigationItem.rightBarButtonItems = []
        }
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.loadData()
        })
        self.tableView.mj_header?.beginRefreshing()
    }

    func loadData() {
        query.addDescendingOrder("createdAt")
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.endRefreshing()
            if let data = result as? [AVObject] {
                if data.count > 0 {
                    self.venueModels.removeAll()
                    for obj in data {
                        let model = WZVenueModel.init(object: obj)
                        self.venueModels.append(model)
                    }
                }
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZVenueCell", for: indexPath) as! WZVenueCell
        cell.model = venueModels[indexPath.row]
        if self.isSelectedMode && self.isSelectingVenue {
            cell.accessoryType = .none
            cell.markImageView.isHidden = (indexPath.row != self.selectedIndex)
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.markImageView.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSelectedMode {
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
        } else {
            self.performSegue(withIdentifier: "showWZVenueDetailViewController", sender: venueModels[indexPath.row])
        }
    }
    
    // 进入/退出选择场馆状态
    @IBAction func selectedButtonAction(_ sender: UIBarButtonItem) {
        if self.isSelectingVenue {
            // 此时点击确认
            if let callback = selectedVenueCallback {
                let model = venueModels[selectedIndex]
                callback(model)
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            self.isSelectingVenue = true
            self.selectedButton.title = "确认".localizedString()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWZVenueDetailViewController" {
            let detailVC = segue.destination as? WZVenueDetailViewController
            detailVC?.model = sender as? WZVenueModel
        }
    }
}
