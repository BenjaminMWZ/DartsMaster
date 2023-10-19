//
//  WZMineViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/6/5.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZMineViewController: WZTableViewController {
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var myTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
    }
    
    // 加载用户信息
    func loadUserInfo() {
        if let currentUser = AVUser.current() {
            // 获取头像
            let headImgFile = currentUser.object(forKey: "headImage") as? AVFile
            if let url = headImgFile?.url() {
                self.headImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
            }
            // 用户名
            self.nameLabel.text = currentUser.username
            // 邮箱
            self.emailLabel.text = currentUser.email
            // 王者、白银、青铜
//            self.myTitleLabel.text = currentUser.object(forKey: "myTitle") as? String
        }
    }
    
    // MARK: -  退出登录
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController.init(title: "温馨提示", message: "确定要退出登录吗？", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .destructive) { action in
            AVUser.logOut()
            // leanCloud 登出
            let loginVC = WZTools.fetchLoginViewController()
            UIApplication.shared.keyWindow?.rootViewController = loginVC
        }
        let cancleAction = UIAlertAction.init(title: "取消", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancleAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
