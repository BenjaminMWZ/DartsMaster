//
//  WZExploreViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/6.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZExploreViewController: WZTableViewController {

    var dataArray = [WZExploreModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }

    func fetchData() {
        let array: [[String: Any]] = [
            ["title": "教程".localizedString(),
             "iconImage": UIImage.init(named: "icon_explore_tutorial")!,
             "startColor": UIColor.init(hexString: "F77823")!,
             "endColor": UIColor.init(hexString: "F8C857")!
            ],
            ["title": "器材".localizedString(),
             "iconImage": UIImage.init(named: "icon_explore_darts")!,
             "startColor": UIColor.init(hexString: "C54224")!,
             "endColor": UIColor.init(hexString: "D15D65")!
            ],
            ["title": "场馆".localizedString(),
             "iconImage": UIImage.init(named: "icon_explore_venue")!,
             "startColor": UIColor.init(hexString: "4B37B7")!,
             "endColor": UIColor.init(hexString: "AE60D0")!
            ],
            ["title": "比赛".localizedString(),
             "iconImage": UIImage.init(named: "icon_explore_match")!,
             "startColor": UIColor.init(hexString: "3455B5")!,
             "endColor": UIColor.init(hexString: "5E9ACF")!
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
        if indexPath.row == 0 { // 教程
            self.performSegue(withIdentifier: "PushToWZTutorialViewController", sender: nil)
        } else if indexPath.row == 1 { // 器材
            self.performSegue(withIdentifier: "ShowWZDartsViewController", sender: nil)
        } else if indexPath.row == 2 { // 场馆
            self.performSegue(withIdentifier: "ShowWZVenueViewController", sender: nil)
        } else if indexPath.row == 3 { // 比赛
            self.performSegue(withIdentifier: "ShowWZMatchViewController", sender: nil)
        }
    }
}
