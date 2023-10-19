//
//  WZEvaluationModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/30.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZEvaluationModel: WZBaseModel {
    var user: AVUser?
    var content: String?
    var starCount: Int = 5
    var createdAt: Date?
    
    override init(object: AVObject) {
        super.init(object: object)
        user = object.object(forKey: "user") as? AVUser
        content = object.object(forKey: "content") as? String
        starCount = (object.object(forKey: "starCount") as? Int) ?? 5
        createdAt = object.object(forKey: "createdAt") as? Date
    }
    
    init(user: AVUser?, content: String?, starCount: Int?, createdAt: Date?) {
        super.init()
        self.user = user
        self.content = content
        self.starCount = starCount ?? 5
        self.createdAt = createdAt
    }
}
