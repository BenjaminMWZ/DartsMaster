//
//  WZTutorialDetailViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTutorialDetailViewController: WZTableViewController {

    var tutorialModel: WZTutorialModel?
    
    /** 标题 */
    @IBOutlet weak var titleLabel: UILabel!
    /** 内容 */
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = self.tutorialModel {
            self.titleLabel.text = model.title
            self.contentLabel.text = model.content
        }
    }
}
