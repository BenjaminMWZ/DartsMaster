//
//  WZMyAppointmentViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/20.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMyAppointmentViewController: WZAppointmentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadData() {
        query.whereKey("sponsor", equalTo: AVUser.current() as Any)
        super.loadData()
    }
}
