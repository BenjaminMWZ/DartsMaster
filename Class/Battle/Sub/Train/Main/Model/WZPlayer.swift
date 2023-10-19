//
//  WZPlayer.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZPlayer: NSObject {
    /** 玩家姓名 */
    var name: String?
    /** 玩家总得分 */
    var score: Int?
    /** 所有得分的记录 */
    var scoreRecord: [Int] = []
    
    func caculateTheScore(basicScore: Int, caculateType: WZScoreCaculateType) -> WZPlayerStaus {
        // 先记录上次得分
        self.scoreRecord.append(self.score!)
        var remainingScore = self.score!
        switch caculateType {
        case .miss:
            remainingScore -= basicScore
        case .double:
            remainingScore -= 2 * basicScore
        case .triple:
            remainingScore -= 3 * basicScore
        case .singleBull:
            remainingScore -= 25
        case .doubleBull:
            remainingScore -= 50
        }
        print("scoreRecord: \(self.scoreRecord)")
        if remainingScore == 0 {
            self.score = remainingScore
            print("Game Over\n The winner is \(name!)")
            return .win
        } else if remainingScore < 0 {
            print("BUST")
            return .bust
        } else {
            self.score = remainingScore
            return .inProgress
        }
    }
    
    func revoke() {
        if self.scoreRecord.count > 0 {
            self.score = self.scoreRecord.last
            self.scoreRecord.removeLast()
        }
        print("scoreRecord: \(self.scoreRecord)")
    }
}
