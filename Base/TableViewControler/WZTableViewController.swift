//
//  WZTableViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/5.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
