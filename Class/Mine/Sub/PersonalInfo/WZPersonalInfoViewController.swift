//
//  WZPersonalInfoViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/3/28.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit

class WZPersonalInfoViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    /** 用户头像 */
    @IBOutlet weak var headerImageView: UIImageView!
    /** 名字 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 邮箱 */
    @IBOutlet weak var emailNumLabel: UILabel!
    /** 用户选择的新头像 */
    var newHeaderImage: UIImage?
    /** 图片选择器 */
    var imagePicker = UIImagePickerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.imagePicker.mediaTypes = ["public.image"]
        self.imagePicker.allowsEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUserData()
    }
    
    func loadUserData() {
        if let currentUser = AVUser.current() {
            self.nameLabel.text = currentUser.username
            self.emailNumLabel.text = currentUser.email
            if let headImgFile = currentUser.object(forKey: "headImage") as? AVFile, let url = headImgFile.url() {
                self.headerImageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.defaultHeadImage)
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 更换头像
            self.showAlertViewController()
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] {
            self.newHeaderImage = image as? UIImage
        } else if let image = info[.originalImage] {
            self.newHeaderImage = image as? UIImage
        }
        self.headerImageView.image = self.newHeaderImage
        self.imagePicker.dismiss(animated: true, completion: nil)
        SVProgressHUD.show(withStatus: "上传中...")
        if let currentUser = AVUser.current(), let imageData = self.newHeaderImage?.jpegData(compressionQuality: 0.1) {
            let headImgFile = AVFile.init(data: imageData, name: "headImage.png")
            currentUser.setObject(headImgFile, forKey: "headImage")
            currentUser.saveInBackground { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                } else {
                    SVProgressHUD.show(withStatus: error?.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Private Method
    func showAlertViewController() {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "相机", style: .default) { action in
            // 设置图片选择器图片来源是相机
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction.init(title: "从相册选择", style: .default) { action in
            // 设置图片选择器图片来源是相册
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel) { action in
            print("点击 Cancle")
        }
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
