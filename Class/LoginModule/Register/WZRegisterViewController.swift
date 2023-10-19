//
//  WZRegisterViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/23.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZRegisterViewController: WZBaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        self.agreeButton.isSelected = !self.agreeButton.isSelected
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if !NSString.isValidEmail(emailTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入正确的邮箱格式".localizedString())
            return
        }
        if NSString.isEmpty(userNameTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入用户名".localizedString())
            return
        }
        if !NSString.isValidPassword(passwordTextField.text) || !NSString.isValidPassword(passwordAgainTextField.text) {
            SVProgressHUD.showError(withStatus: "请输入6~12位有效密码,只能包含字母、数字、_@#$%".localizedString())
            return
        }
        if passwordTextField.text != passwordAgainTextField.text {
            SVProgressHUD.showError(withStatus: "两次输入的密码不一致".localizedString())
            return
        }
        if self.agreeButton.isSelected == false {
            SVProgressHUD.showError(withStatus: "请同意用户服务协议".localizedString())
            return
        }
        SVProgressHUD.show(withStatus: "注册中...".localizedString())
        // 用户名+密码注册
        let user = AVUser.init()
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.username = self.userNameTextField.text
        // 设置用户注册后的默认头像
//        let defaultHeadImage = UIImage.init(named: "icon_headImage")
        if let headImageData = UIImage.defaultHeadImage?.pngData() {
            let headImageFile = AVFile.init(data: headImageData, name: "headImage.png")
            user.setObject(headImageFile, forKey: "headImage")
        }
        
        user.signUpInBackground { (success, error) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "恭喜您, 注册成功, 已向您的邮箱发送一封含有验证链接的邮件, 请点击链接进行验证".localizedString())
                self.dismiss(animated: true, completion: nil)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    @IBAction func backToLoginAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
