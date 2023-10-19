//
//  WZAppointmentModel.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/31.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAppointmentModel: WZBaseModel {
    var appointmentId: String?
    /** 约战发起人 */
    var sponsor: AVUser?
    /** 场馆 */
    var venue: AVObject?
    /** 场馆数据模型 */
    var venueModel: WZVenueModel?
    /** 约定时间 */
    var date: Date?
    /** 应战的用户 */
    var acceptedUsers: [AVUser] = []
    
    override init(object: AVObject) {
        super.init()
        appointmentId = object.objectId
        sponsor = object.object(forKey: "sponsor") as? AVUser
        venue = object.object(forKey: "venue") as? AVObject
        if let venue = venue {
            venueModel = WZVenueModel.init(object: venue)
        }
        date = object.object(forKey: "date") as? Date
        if let users = object.object(forKey: "acceptedUsers") as? [AVUser] {
            acceptedUsers = users
        }
    }
}
