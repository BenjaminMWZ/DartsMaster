//
//  WZAddCommentViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/12.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit
import QMUIKit

class WZAddCommentViewController: UIViewController {

    @IBOutlet weak var textView: QMUITextView!
    var model: WZSocialModel?
    var callBack: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 添加评论
    @IBAction func addCommentAction(_ sender: UIButton) {
        if NSString.isEmpty(textView.text) {
            SVProgressHUD.showError(withStatus: "请输入评论内容")
            return
        }
        if let model = model {
            let comment = AVObject.init(className: "Comment")
            comment.setObject(textView.text, forKey: "content")
            comment.setObject(AVUser.current(), forKey: "user")
            comment.setObject(model.postObject, forKey: "post")
            comment.setObject(model.postBy, forKey: "postBy")
            SVProgressHUD.show(withStatus: "发布中...")
            comment.saveInBackground { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "评论成功")
                    if let callBack = self.callBack {
                        callBack()
                    }
                    model.postObject?.incrementKey("commentNumber", byAmount: 1)
                    model.postObject?.saveInBackground()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "评论失败, 请重试")
                }
            }
        }
    }
}
