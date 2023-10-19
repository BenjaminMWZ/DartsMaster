//
//  WZAgreementViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAgreementViewController: WZBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
