//
//  WZBattleViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/10.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZBattleViewController: WZTableViewController {

    var dataArray = [WZExploreModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }

    func fetchData() {
        let array: [[String: Any]] = [
            ["title": "训练".localizedString(),
             "iconImage": UIImage.init(named: "icon_battle_train")!,
             "startColor": UIColor.init(hexString: "0A7A7D")!,
             "endColor": UIColor.init(hexString: "57A68A")!
            ],
            ["title": "约战".localizedString(),
             "iconImage": UIImage.init(named: "icon_battle_dule")!,
             "startColor": UIColor.init(hexString: "788CFF")!,
             "endColor": UIColor.init(hexString: "9C56EC")!
            ],
        ]
        for dict in array {
            let model = WZExploreModel.init(title: dict["title"] as! String, iconImage: dict["iconImage"] as! UIImage, startColor: dict["startColor"] as! UIColor, endColor: dict["endColor"] as! UIColor)
            self.dataArray.append(model)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZExploreCell", for: indexPath) as! WZExploreCell
        cell.model = self.dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "ShowWZTrainConfigViewController", sender: nil)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "ShowWZAppointmentViewController", sender: nil)
        }
    }
}
