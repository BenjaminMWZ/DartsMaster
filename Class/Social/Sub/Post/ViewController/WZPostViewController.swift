//
//  WZPostViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/12.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit
import QMUIKit
import TZImagePickerController

class WZPostViewController: UITableViewController {
    
    @IBOutlet weak var textView: QMUITextView!
    var assetModel: WZPostAssetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.assetModel?.postType == .video { // 预览视频
            if let asset = self.assetModel?.assets?.first as? PHAsset {
                let videoPlayerController = TZVideoPlayerController.init()
                let model = TZAssetModel.init(asset: asset, type: TZAssetModelMediaTypeVideo)
                videoPlayerController.model = model
                videoPlayerController.modalPresentationStyle = .fullScreen
                self.present(videoPlayerController, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.assetModel?.postType == .text {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.assetModel?.postType == .video { // 视频
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZPostViedoTableViewCell", for: indexPath) as! WZPostVideoTableViewCell
            cell.assetModel = self.assetModel
            return cell
        } else { // 图文
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZPostImageTableViewCell", for: indexPath) as! WZPostImageTableViewCell
            cell.assetModel = self.assetModel
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: --  Event Response --

    @IBAction func postButtonAction(_ sender: UIBarButtonItem) {
        if let model = self.assetModel {
            let post = AVObject.init(className: "Post")
            post.setObject(AVUser.current(), forKey: "postBy")
            post.setObject(self.textView.text ?? "", forKey: "content")
            post.setObject(model.postType.rawValue, forKey: "postType")

            switch model.postType {
            case .text:
                if NSString.isEmpty(self.textView.text) {
                    SVProgressHUD.showError(withStatus: "输入这一刻的想法")
                    return
                }
            case .imageText:
                if let photos = model.photos {
                    if photos.count > 0 {
                        var photoFiles = Array<AVFile>.init()
                        for photo in photos {
                            if let photoData = photo.jpegData(compressionQuality: 0.5) {
                                let photoFile = AVFile.init(data: photoData, name: "image.png")
                                photoFiles.append(photoFile)
                            }
                        }
                        post.addObjects(from: photoFiles, forKey: "photos")
                    }
                }
            case .video:
                if let coverImage = model.videoCoverImage, let coverImageData = coverImage.jpegData(compressionQuality: 0.5) {
                    let coverImageFile = AVFile.init(data: coverImageData)
                    post.setObject(coverImageFile, forKey: "coverImage")
                }
                if let videoPath = model.videoPath, let data = NSData.init(contentsOfFile: videoPath) {
                    let videoFile = AVFile.init(data: data as Data, name: "video.mp4")
                    post.setObject(videoFile, forKey: "video")
                }
            }
            SVProgressHUD.show(withStatus: "发布中...")
            // 将对象保存到云端
            post.saveInBackground { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "发布成功")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }
}
