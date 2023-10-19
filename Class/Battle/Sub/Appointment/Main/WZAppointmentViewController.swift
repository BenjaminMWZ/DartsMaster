//
//  WZAppointmentViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAppointmentViewController: WZTableViewController {
    
    var pageNumber = 0
    var appointmentModels: [WZAppointmentModel] = []
    lazy var query: AVQuery = {
        let query = AVQuery.init(className: "Appointment")
        query.addDescendingOrder("createdAt")
        query.includeKey("sponsor")
        query.includeKey("venue")
        query.includeKey("acceptedUser")
        query.limit = kPageSize
        query.cachePolicy = .networkElseCache
        return query
    }()
    
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
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header?.beginRefreshing()
    }

    func loadData() {
        query.skip = pageNumber * kPageSize
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
                        self.appointmentModels.removeAll()
                    }
                    if data.count > 0 {
                        for obj in data {
                            let model = WZAppointmentModel.init(object: obj)
                            self.appointmentModels.append(model)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZAppointmentCell", for: indexPath) as! WZAppointmentCell
        cell.model = appointmentModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWZAppointmentDetailController", sender: indexPath.row)
    }
    
    // MARK: --  Event Response --

    /** 点击发起约战 */
    @IBAction func makeAppointmentButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowWZMakeAppointmentViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZAppointmentDetailController" { // 约战详情
            let detailVC = segue.destination as? WZAppointmentDetailController
            let index = sender as! Int
            detailVC?.model = appointmentModels[index]
            detailVC?.acceptSuccessCallback = { model in
                self.appointmentModels[index] = model
            }
        } else if segue.identifier == "ShowWZMakeAppointmentViewController" { // 发起约战
            let makeAppointmentVC = segue.destination as? WZMakeAppointmentViewController
            makeAppointmentVC?.makeAppointmentSuccessCallback = { model in
                self.appointmentModels.insert(model, at: 0)
                self.tableView.reloadData()
            }
        }
    }
}
