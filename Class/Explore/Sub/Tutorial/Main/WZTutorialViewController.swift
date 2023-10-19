//
//  WZTutorialViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/12.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTutorialViewController: WZTableViewController, WZTutorialCellDelegate {
    
    var beginnerTutorials: [WZTutorialModel] = []
    var advancedTutorials: [WZTutorialModel] = []
    var masterTutorials: [WZTutorialModel] = []
    var sectionTitles = ["新手教程".localizedString(), "进阶教程".localizedString(), "大师教程".localizedString()]
    let query = AVQuery.init(className: "Tutorial")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.fetchData()
        })
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func fetchData() {
        query.getFirstObjectInBackground { (object, error) in
            self.tableView.mj_header?.endRefreshing()
            if let obj = object {
                if let beginner = obj.object(forKey: "beginner") as? [[String: String]] {
                    self.beginnerTutorials.removeAll()
                    for item in beginner {
                        let model = WZTutorialModel.init(dict: item)
                        self.beginnerTutorials.append(model)
                    }
                }
                if let advanced = obj.object(forKey: "advanced") as? [[String: String]] {
                    self.advancedTutorials.removeAll()
                    for item in advanced {
                        let model = WZTutorialModel.init(dict: item)
                        self.advancedTutorials.append(model)
                    }
                }
                if let master = obj.object(forKey: "master") as? [[String: String]] {
                    self.masterTutorials.removeAll()
                    for item in master {
                        let model = WZTutorialModel.init(dict: item)
                        self.masterTutorials.append(model)
                    }
                }
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZTutorialCell", for: indexPath) as! WZTutorialCell
        cell.delegate = self
        if indexPath.section == 0 {
            cell.tutorials = self.beginnerTutorials
        } else if indexPath.section == 1 {
            cell.tutorials = self.advancedTutorials
        } else if indexPath.section == 2 {
            cell.tutorials = self.masterTutorials
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: -- WZTutorialCellDelegate --
    
    func tutorialCellDidSelectItem(_ itemModel: WZTutorialModel?) {
        self.performSegue(withIdentifier: "ShowWZTutorialDetailViewController", sender: itemModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZTutorialDetailViewController" {
            let tutorialDetailVC = segue.destination as! WZTutorialDetailViewController
            tutorialDetailVC.tutorialModel = sender as? WZTutorialModel
        }
    }
}
