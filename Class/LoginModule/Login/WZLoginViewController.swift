//
//  WZLoginViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZLoginViewController: WZBaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        self.agreeButton.isSelected = !self.agreeButton.isSelected
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if !NSString.isValidEmail(emailTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入正确的邮箱格式".localizedString())
            return
        }
        if !NSString.isValidPassword(passwordTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入6~12位有效密码,只能包含字母、数字、_@#$%".localizedString())
            return
        }
        if self.agreeButton.isSelected == false {
            SVProgressHUD.showError(withStatus: "请同意用户服务协议".localizedString())
            return
        }
        SVProgressHUD.show(withStatus: "登录中...".localizedString())
        AVUser.login(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
//                SVProgressHUD.showSuccess(withStatus: "登录成功")
                UIApplication.shared.keyWindow?.rootViewController = WZTools.fetchRootTabBarViewController()
            } else {
                if let error = error as NSError?, error.code == 216 {
                    SVProgressHUD.dismiss()
                    self.requestEmailVerify()
                } else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }
    
    func requestEmailVerify() {
        let alertController = UIAlertController.init(title: "您的邮箱未验证".localizedString(), message: "点击邮箱中收到的验证邮件后可以登录".localizedString(), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "好的".localizedString(), style: .cancel, handler: nil)
        let resendAction = UIAlertAction.init(title: "重新发送".localizedString(), style: .default) { (action) in
            SVProgressHUD.show()
            AVUser.requestEmailVerify(self.emailTextField.text!) { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "邮件已发送, 请注意查收".localizedString())
                } else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
        alertController.addAction(resendAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
