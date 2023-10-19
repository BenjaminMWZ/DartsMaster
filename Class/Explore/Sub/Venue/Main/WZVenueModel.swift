//
//  WZVenueModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/30.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZVenueModel: WZBaseModel {
    var venueId: String?
    /** 俱乐部名字 */
    var clubName: String?
    /** 地址 */
    var address: String?
    /** 评价数 */
    var evaluationCount: Int = 0
    /** 图片 */
    var imageUrls: [String]?
    /** 联系电话 */
    var phoneNumber: String?
    /** 价格 */
    var price: Int = 0
    /** 星级 */
    var starCount: Int = 0
    
    override init(object: AVObject) {
        super.init(object: object)
        venueId = object.objectId
        clubName = object.object(forKey: "clubName") as? String
        address = object.object(forKey: "address") as? String
        evaluationCount = (object.object(forKey: "evaluationCount") as? Int) ?? 0
        imageUrls = object.object(forKey: "imageUrls") as? [String]
        phoneNumber = object.object(forKey: "phoneNumber") as? String
        price = (object.object(forKey: "price") as? Int) ?? 0
        starCount = (object.object(forKey: "starCount") as? Int) ?? 0
    }
}
