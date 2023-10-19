//
//  WZCommentModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZCommentModel: NSObject {
    var user: AVUser?
    var postBy: AVUser?
    var content: String?
    var date: String?
    
    init(commentObject: AVObject) {
        self.user = commentObject.object(forKey: "user") as? AVUser
        self.postBy = commentObject.object(forKey: "postBy") as? AVUser
        self.content = commentObject.object(forKey: "content") as? String
        if let createDate = commentObject.createdAt {
            self.date = KFTDateTool.string(from: createDate, dateFormat: "yyyy.MM.dd HH:mm")
        }
    }
}
