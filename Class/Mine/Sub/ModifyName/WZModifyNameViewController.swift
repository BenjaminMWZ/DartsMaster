//
//  WZModifyNameViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/4/4.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit
import SVProgressHUD

class WZModifyNameViewController: UIViewController {
    /** 姓名输入框 */
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.becomeFirstResponder()
    }
    
    /** 点击完成 */
    @IBAction func confirmButtonAction(_ sender: Any) {
        if textField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入新的名字")
            return
        }
        SVProgressHUD.show()
        let currentUser = AVUser.current()
        currentUser?.username = textField.text
        currentUser?.saveInBackground({ (success, error) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        })
    }
}
