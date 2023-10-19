//
//  WZMatchModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/30.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMatchModel: WZBaseModel {
    var coverImage: AVFile?
    var detailUrl: String?
    var title: String?
    var source: String?
    var createdAt: Date?
    
    override init(object: AVObject) {
        super.init()
        coverImage = object.object(forKey: "coverImage") as? AVFile
        detailUrl = object.object(forKey: "detailUrl") as? String
        title = object.object(forKey: "title") as? String
        source = object.object(forKey: "source") as? String
        createdAt = object.object(forKey: "createdAt") as? Date
    }
}
