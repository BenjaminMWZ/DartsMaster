//
//  WZDartsModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/29.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZDartsModel: WZBaseModel {
    /** 图片 */
    var imageUrls: [String]?
    /** 测评 */
    var evaluation: String?
    /** 外观 */
    var look: String?
    /** 材质 */
    var material: String?
    /** 飞镖名称 */
    var name: String?
    /** 价格 */
    var price: Int?
    /** 星级 */
    var starCount: Int?
    /** 重量 */
    var weight: Int?
    
    override init(object: AVObject) {
        super.init(object: object)
        imageUrls = object.object(forKey: "imageUrls") as? [String]
        evaluation = object.object(forKey: "evaluation") as? String
        look = object.object(forKey: "look") as? String
        material = object.object(forKey: "material") as? String
        name = object.object(forKey: "name") as? String
        price = object.object(forKey: "price") as? Int
        starCount = object.object(forKey: "starCount") as? Int
        weight = object.object(forKey: "weight") as? Int
    }
}
