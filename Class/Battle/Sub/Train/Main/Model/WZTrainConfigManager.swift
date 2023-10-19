//
//  WZTrainConfigManager.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/24.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

/// 计分规则类型
enum WZTrainScoreStyle: Int {
    case type301 = 301
    case type501 = 501
    case type701 = 701
    case type901 = 901
    case type1001 = 1001
}

// 得分类型
enum WZScoreCaculateType: Int {
    case double = 0 // 基础分的2倍
    case triple = 1 // 基础分的3倍
    case miss = 2 // 本次不积分
    case singleBull = 3 // 靶心外心
    case doubleBull = 4 // 靶心内心
}

// 每次计算完得分后的结果
enum WZPlayerStaus {
    case win // 赢得胜利
    case bust // 爆镖
    case inProgress // 游戏中
}

class WZTrainConfigManager: NSObject {
    // 设置页面选择的积分规则
    var scoreStyle: WZTrainScoreStyle = .type301
    // 设置页面输入的玩家个数
    var playerCount: Int = 1 {
        didSet {
            configPlayers()
        }
    }
    
    // 回合数
    var roundCount = 1
    
    // 玩家列表
    var players: [WZPlayer] = []
    // 当前玩家
    var currentPlayer: WZPlayer?
    // 当前玩家在玩家列表中的下标
    var currentPlayerIndex: Int = 0 {
        didSet {
            guard currentPlayerIndex >= 0 && currentPlayerIndex < players.count  else {
                return
            }
            currentPlayer = players[currentPlayerIndex]
        }
    }
    // 基础分数
    lazy var basicScores: [Int] = {
        var scores = [Int]()
        for i in (1...20).reversed() {
            scores.append(i)
        }
        return scores
    }()
    
    // 初始化玩家信息
    func configPlayers() {
        for i in 1...playerCount {
            let player = WZPlayer.init()
            player.score = scoreStyle.rawValue
            player.name =  "PLAYER\(i)"
            players.append(player)
        }
        currentPlayer = players.first
    }
    
    // 重新开始, 重置玩家分数
    func resetPlayerScore() {
        for player in players {
            player.score = scoreStyle.rawValue
            player.scoreRecord.removeAll()
        }
        currentPlayer = players.first
        roundCount = 1
    }
    
    // 撤回本次操作
    func revoke() {
        currentPlayer?.revoke()
    }
    
    // 添加一个玩家
    func addOnePlayer() {
        let player = WZPlayer.init()
        player.score = scoreStyle.rawValue
        player.name =  "PLAYER\(players.count + 1)"
        players.append(player)
    }
    
    // 删除某个玩家
    func removePlayer(at index: Int) {
        guard index >= 0 && index < players.count  else {
            return
        }
        players.remove(at: index)
        if currentPlayerIndex == index {
            currentPlayer = players.first
        }
    }
    
    func nextRound() {
        roundCount += 1
    }
}
