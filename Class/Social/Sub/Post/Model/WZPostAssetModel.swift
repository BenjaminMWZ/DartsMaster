//
//  WZPostAssetModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/21.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

/// 发布朋友圈枚举类型
enum WZPostType: Int {
    case text = 1 // 文字
    case video = 2 // 文字和视频
    case imageText = 3 // 文字和图片
}

class WZPostAssetModel: NSObject {
    // 选择的图片资源
    var photos: [UIImage]?
    var assets: [Any]?
    // 选择的视频资源路径
    var videoPath: String?
    // 选择的视频封面图片
    var videoCoverImage: UIImage?
    // 发布内容类型
    var postType: WZPostType = .text
}
