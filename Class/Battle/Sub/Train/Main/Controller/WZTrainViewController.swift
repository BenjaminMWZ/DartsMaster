//
//  WZTrainViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import LTMorphingLabel

class WZTrainViewController: WZTableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /** 配置信息 */
    var configManager: WZTrainConfigManager = WZTrainConfigManager.init()
    /** 计算分值类型 */
    var caculateType: WZScoreCaculateType = .miss
    /** 回合数 */
    @IBOutlet weak var roundLabel: LTMorphingLabel!
    /** 玩家列表 */
    @IBOutlet weak var playerCollectionView: UICollectionView!
    /** 基础分列表 */
    @IBOutlet weak var middleCollectionView: UICollectionView!
    var dismissCallback: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setup() {
        roundLabel.morphingEffect = .burn
        playerCollectionView.delegate = self
        playerCollectionView.dataSource = self
    }

    // MARK: --  UITableViewDelegate --

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        if indexPath.section == 0 {
            return screenHeight <= 667 ? 240 : 250
        } else {
            return  screenHeight <= 667 ? 150 : 190
        }
    }
    
    // MARK: --  UICollectionViewDelegate --

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.playerCollectionView {
            self.configManager.currentPlayerIndex = indexPath.item
            self.playerCollectionView.reloadData()
        } else {
            let basicScore = self.configManager.basicScores[indexPath.item]
            print("basic score: \(basicScore)")
            self.reloadPlayerScore(basicScore: basicScore, caculateType: self.caculateType)
        }
    }
    
    // MARK: --  UICollectionViewDataSource --
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.playerCollectionView {
            return self.configManager.players.count
        } else {
            return self.configManager.basicScores.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.playerCollectionView { // 玩家列表
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZTrainPlayerCell", for: indexPath) as! WZTrainPlayerCell
            let model = self.configManager.players[indexPath.item]
            cell.player = model
            cell.isSelected = (self.configManager.currentPlayerIndex == indexPath.item)
            cell.deleteButton.isHidden = (self.configManager.players.count == 1)
            cell.deleteButton.tag = 100 + indexPath.item
            cell.deleteButton.addTarget(self, action: #selector(deleteOnePlayerButtonAction(sender:)), for: .touchUpInside)
            return cell
        } else { // 分值列表
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZTrainScoreItemCell", for: indexPath) as! WZTrainScoreItemCell
            cell.titleLabel.text = "\(self.configManager.basicScores[indexPath.item])"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.playerCollectionView {
            let itemWidth = collectionView.bounds.size.width/CGFloat(min(3, self.configManager.players.count))
            return CGSize.init(width: itemWidth, height: collectionView.bounds.size.height)
        } else {
            let itemHeight = collectionView.bounds.size.height/5
            let itemWidth = collectionView.bounds.size.width/4
            return CGSize.init(width: itemWidth, height: itemHeight)
        }
    }
    
    // MARK: --  Event Response --

    /** 退出训练页面 */
    @IBAction func backButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if dismissCallback != nil { dismissCallback!() }
    }
    
    /** 重新开始 */
    @IBAction func restartButtonAction(_ sender: UIButton?) {
        self.configManager.resetPlayerScore()
        roundLabel.text = "ROUND \(configManager.roundCount)"
        self.playerCollectionView.reloadData()
    }
    
    /** 撤销 */
    @IBAction func revokeButtonAction(_ sender: UIButton) {
        self.configManager.revoke()
        self.playerCollectionView.reloadData()
    }
    
    /** 增加一个玩家 */
    @IBAction func addOnePlayerButtonAction(sender: UIButton) {
        self.configManager.addOnePlayer()
        self.playerCollectionView.reloadData()
    }
    
    /** 删除一个玩家 */
    @objc func deleteOnePlayerButtonAction(sender: UIButton) {
        let index = sender.tag - 100
        self.configManager.removePlayer(at: index)
        self.playerCollectionView.reloadData()
    }
    
    /** 下一轮 */
    @IBAction func nextRoundButtonAction(_ sender: UIButton) {
        configManager.nextRound()
        roundLabel.text = ""
        roundLabel.text = "ROUND \(configManager.roundCount)"
    }
    
    /** 选择是否有加成分数 */
    @IBAction func selectScoreCaculateAction(_ sender: UIButton) {
        if let caculateType = WZScoreCaculateType.init(rawValue: sender.tag - 100) {
            self.caculateType = caculateType
            if caculateType == .singleBull || caculateType == .doubleBull {
                self.reloadPlayerScore(basicScore: 0, caculateType: self.caculateType)
            }
        }
    }
    
    /** 计算本次玩家分数并刷新页面 */
    func reloadPlayerScore(basicScore: Int, caculateType: WZScoreCaculateType) {
        let playerStatus = self.configManager.currentPlayer?.caculateTheScore(basicScore: basicScore, caculateType: self.caculateType)
        self.playerCollectionView.reloadData()
        self.caculateType = .miss
        switch playerStatus {
        case .win:
            let alertController = UIAlertController.init(title: "Game Over", message: "Congratulation ,The winner is \(self.configManager.currentPlayer?.name ?? "")!", preferredStyle: .alert)
            let restartAction = UIAlertAction.init(title: "Restart", style: .default) { (action) in
                self.restartButtonAction(nil)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        case .bust:
            let alertController = UIAlertController.init(title: "BUST", message: " \(self.configManager.currentPlayer?.name ?? "") have been bust!", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
}
