//
//  WZPasswordResetViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/20.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZPasswordResetViewController: UIViewController {

    /** 邮箱 */
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /** 重置 */
    @IBAction func resetButtonAction(_ sender: UIButton) {
        if !NSString.isValidEmail(emailTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入正确的邮箱格式")
            return
        }
        SVProgressHUD.show()
        AVUser.requestPasswordResetForEmail(inBackground: emailTextField.text!) { (success, error) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "已发送一封包含重置密码的特殊链接的电子邮件到您的邮箱")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
}
