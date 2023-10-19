//
//  HYMyCollectModel.swift
//  cooking
//
//  Created by 马冰垒 on 2020/7/22.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

class WZMyCollectModel: WZBaseModel {
    var post: AVObject?
    var user: AVUser?
    var postModel: WZSocialModel?
    
    override init(object: AVObject) {
        super.init(object: object)
        post = object.object(forKey: "post") as? AVObject
        user = object.object(forKey: "user") as? AVUser
        if let post = post {
            postModel = WZSocialModel.init(postObject: post)
            postModel?.collected = true
            postModel?.postBy = AVUser.current()
        }
    }
}
