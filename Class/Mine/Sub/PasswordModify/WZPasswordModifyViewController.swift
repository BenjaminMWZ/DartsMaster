//
//  WZPasswordModifyViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/6.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZPasswordModifyViewController: UIViewController {

    /** 原密码 */
    @IBOutlet weak var originalPwdTextField: UITextField!
    /** 新密码 */
    @IBOutlet weak var newPwdTextField: UITextField!
    /** 再次确认密码 */
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /** 确认按钮 */
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        if originalPwdTextField.text?.isEmpty == true {
            SVProgressHUD.showError(withStatus: "请输入原密码")
            return
        }
        if NSString.isValidPassword(self.newPwdTextField.text!) == false || NSString.isValidPassword(self.confirmTextField.text!) == false {
            SVProgressHUD.showError(withStatus: "请输入6~12位有效密码,只能包含字母、数字、_@#$%")
            return
        }
        if newPwdTextField.text != confirmTextField.text {
            SVProgressHUD.showError(withStatus: "两次输入密码不一致,请重新输入")
            return
        }
        SVProgressHUD.show()
        let user = AVUser.current()
        user?.updatePassword(self.originalPwdTextField.text!, newPassword: self.newPwdTextField.text!, block: { (object, error) in
            if error == nil {
                SVProgressHUD.showSuccess(withStatus: "修改密码成功")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        })
    }
}
