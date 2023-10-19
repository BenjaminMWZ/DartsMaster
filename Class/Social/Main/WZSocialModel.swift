//
//  WZSocialModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import Foundation

class WZSocialModel: NSObject {
    var postObject: AVObject?
    // 帖子 id
    var postId: String?
    // 发布人
    var postBy: AVUser?
    // 发布的内容
    var content: String?
    // 发布的图片文件
    var photoFiles: [AVFile]?
    // 发布的视频封面
    var coverImageFile: AVFile?
    // 发布的视频文件
    var videoFiles: AVFile?
    var photosUrl: [URL] = []
    var postType: WZPostType = .text
    var creatDate: String?
    var collectNumber: Int = 0
    var commentNumber: Int = 0
    var likeNumber: Int = 0
    var reportCount: Int = 0
    var collected: Bool = false
    var query = AVQuery.init(className: "Collect")
    
    init(postObject: AVObject) {
        super.init()
        self.postObject = postObject
        self.postId = postObject.objectId
        self.postBy = postObject.object(forKey: "postBy") as? AVUser
        self.content = postObject.object(forKey: "content") as? String
        if let date = postObject.createdAt {
            self.creatDate = KFTDateTool.string(from: date, dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        self.photoFiles = postObject.object(forKey: "photos") as? [AVFile]
        if let postType = postObject.object(forKey: "postType") as? Int {
            self.postType = WZPostType.init(rawValue: postType)!
        }
        self.coverImageFile = postObject.object(forKey: "coverImage") as? AVFile
        self.videoFiles = postObject.object(forKey: "video") as? AVFile
        self.collectNumber = postObject.object(forKey: "collectNumber") as! Int
        self.commentNumber = postObject.object(forKey: "commentNumber") as! Int
        self.likeNumber = postObject.object(forKey: "likeNumber") as! Int
        self.reportCount = postObject.object(forKey: "reportCount") as! Int
        
        if let photoFiles = self.photoFiles {
            if photoFiles.count > 0 {
                for file in photoFiles {
                    if let urlString = file.url(), let url = URL.init(string: urlString) {
                        self.photosUrl.append(url)
                    }
                }
            }
        }
        self.query.whereKey("post", equalTo: postObject)
        self.query.whereKey("user", equalTo: AVUser.current() as Any)
        self.query.cachePolicy = .cacheElseNetwork
        self.query.getFirstObjectInBackground { (objc, error) in
            self.collected = (objc != nil)
        }
    }
}
