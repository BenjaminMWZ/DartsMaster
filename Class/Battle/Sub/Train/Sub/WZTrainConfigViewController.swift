//
//  WZTrainConfigViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/24.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTrainConfigViewController: UITableViewController {

    @IBOutlet weak var playerCountTextField: UITextField!
    var dataArray = [301, 501, 701, 901, 1001]
    var currentSelectedRow = 0
    var configManager = WZTrainConfigManager.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "选择计分类型".localizedString()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "输入玩家个数".localizedString()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedRow = indexPath.row
        configManager.scoreStyle = WZTrainScoreStyle(rawValue: dataArray[currentSelectedRow])!
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZTrainConfigCell", for: indexPath) as! WZTrainConfigCell
        cell.titleLabel.text = "\(self.dataArray[indexPath.row])"
        cell.isSelected = (currentSelectedRow == indexPath.row)
        
        return cell
    }
    
    // 确认
    @IBAction func confirmButtonAction(_ sender: UIBarButtonItem) {
        self.configManager.playerCount = Int(playerCountTextField.text ?? "") ?? 1
        self.performSegue(withIdentifier: "ShowWZTrainViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZTrainViewController" {
            let trainVC = segue.destination as! WZTrainViewController
            trainVC.configManager = self.configManager
            trainVC.dismissCallback = {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}
