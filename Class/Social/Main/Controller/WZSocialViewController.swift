//
//  WZSocialViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import TZImagePickerController

let kSeguePushSocialDetail = "ShowWZSocialDetailViewController"
let kSeguePushPostViewController = "ShowWZPostViewController"

class WZSocialViewController: WZTableViewController, HyPopMenuViewDelegate, TZImagePickerControllerDelegate {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    // 弹出视图
    var menuView = HyPopMenuView.sharedPopMenuManager()!
    let videoMaximumDuration: TimeInterval = 10
    var assetModel = WZPostAssetModel.init()
    // 朋友圈动态数据
    var socialModels: [WZSocialModel] = []
    var pageNumber: Int = 0
    let query = AVQuery.init(className: "Post")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton.image = self.rightBarButton.image?.withRenderingMode(.alwaysOriginal)
        meumSetting()
        customTableViewHeaderAndFooter()
    }
    
    // 初始化菜单设置
    func meumSetting() {
        var menuDataArray = [PopMenuModel].init()
        let dataArray = [["iconName":"icon_social_video","title":"视频"],
        ["iconName":"icon_social_image","title":"图片"],
        ["iconName":"icon_social_text","title":"文字"]]
        for dict in dataArray {
            let model = PopMenuModel.allocPopMenuModel(withImageNameString: dict["iconName"]!, atTitleString: dict["title"]!, atTextColor: UIColor.init(hexString: "333333"), at: PopMenuTransitionTypeSystemApi, atTransitionRenderingColor: nil)
            menuDataArray.append(model)
        }
        self.menuView.dataSource = menuDataArray;
        self.menuView.delegate = self;
        self.menuView.popMenuSpeed = 12.0
        self.menuView.automaticIdentificationColor = false;
        self.menuView.animationType = .sina
        self.menuView.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
    }

    func customTableViewHeaderAndFooter() {
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.pageNumber = 0
            self.tableView.mj_footer?.isHidden = true
            self.requestData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.pageNumber += 1
            self.tableView.mj_header?.isHidden = false
            self.requestData()
        })
        self.tableView.mj_header?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func requestData() {
        query.limit = kPageSize
        query.skip = kPageSize * self.pageNumber
        query.includeKey("postBy")
        query.includeKey("photos")
        query.includeKey("video")
        query.includeKey("coverImage")
        query.addDescendingOrder("createdAt")
        query.cachePolicy = .networkElseCache
        
        query.findObjectsInBackground { (result, error) in
            self.tableView.mj_header?.isHidden = false
            self.tableView.mj_footer?.isHidden = false
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if error != nil {
                SVProgressHUD.show(withStatus: error?.localizedDescription)
            } else {
                if let posts = result as? [AVObject] {
                    if posts.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if self.pageNumber == 0 {
                        self.socialModels.removeAll()
                    }
                    if posts.count > 0 {
                        for postObject in posts {
                            let postModel = WZSocialModel.init(postObject: postObject)
                            self.socialModels.append(postModel)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.socialModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postType = self.socialModels[indexPath.row].postType
        let model = self.socialModels[indexPath.row]
        switch postType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialTextCell", for: indexPath) as! WZSocialTextCell
            cell.model = model
            return cell
        case .imageText:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialImageCell", for: indexPath) as! WZSocialImageCell
            cell.model = model
//            cell.collectionViewDidSelectedCallBack = {
//                self.performSegue(withIdentifier: "PushToSocialDetailViewController", sender: indexPath.row)
//            }
            return cell
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WZSocialVideoCell", for: indexPath) as! WZSocialVideoCell
            cell.model = model
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kSeguePushSocialDetail, sender: indexPath.row)
    }
    
    // MARK: -- HyPopMenuViewDelegate --
    
    func popMenuView(_ popMenuView: HyPopMenuView!, didSelectItemAt index: UInt) {
        if index == 0 { // 视频
            self.assetModel.postType = .video
            self.showImagePickerToSelectVideo()
        } else if index == 1 { // 图文
            self.assetModel.postType = .imageText
            self.showImagePickerToSelectImages()
        } else if index == 2 { // 文字
            self.assetModel.postType = .text
            self.toPostViewController()
        }
    }
    
    // MARK: -- Event Response --

        // 跳转到发布页面
        func toPostViewController() {
            self.performSegue(withIdentifier: kSeguePushPostViewController, sender: nil)
        }
        
        // 选择图像
        func showImagePickerToSelectImages() {
            let imagePickerController = TZImagePickerController.init(maxImagesCount: 9, delegate: self)!
            imagePickerController.allowPickingVideo = false
            imagePickerController.allowTakeVideo = false
            imagePickerController.modalPresentationStyle = .fullScreen
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        // 选择视频
        func showImagePickerToSelectVideo() {
            let imagePickerController = TZImagePickerController.init(maxImagesCount: 1, delegate: self)!
            imagePickerController.allowPickingVideo = true
            imagePickerController.allowPickingImage = false
            imagePickerController.allowTakePicture = false
            imagePickerController.videoMaximumDuration = videoMaximumDuration
            imagePickerController.modalPresentationStyle = .fullScreen
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        // 设置是否可以被选中
    //    func isAssetCanSelect(_ asset: PHAsset!) -> Bool {
    //        var canSelected = true
    //        switch asset.mediaType {
    //        case .video:
    //            // 视频时长
    //            let duration = asset.duration
    //            if (duration < 1 || duration > 10) {
    //                canSelected = false
    //            }
    //        case .image:
    //            // 图片尺寸
    //            if (asset.pixelWidth > 3000 || asset.pixelHeight > 3000) {
    //                canSelected = false
    //            }
    //        default: break
    //        }
    //        return canSelected
    //    }
        
        // MARK: -- QMUIImagePickerViewControllerDelegate --

        // 选择图片结束后
        func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
            self.assetModel.photos = photos
            self.assetModel.assets = assets
            self.toPostViewController()
        }
        
        // 选择视频结束后
        func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
            TZImageManager.default()?.getVideoOutputPath(with: asset, presetName: AVAssetExportPresetLowQuality, success: { (outputPath) in
                print("视频导出到本地完成,沙盒路径为: \(String(describing: outputPath))")
                self.assetModel.videoCoverImage = coverImage
                self.assetModel.videoPath = outputPath
                self.assetModel.assets = [asset as Any]
                self.toPostViewController()
            }, failure: { (errorMsg, error) in
                print("视频导出失败: \(String(describing: errorMsg)),error: \(String(describing: error))")
            })
        }
    
    // 右侧按钮点击
    @IBAction func rightBarButtonAction(_ sender: UIBarButtonItem) {
        self.menuView.openMenu()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSeguePushPostViewController {
            let postVC = segue.destination as! WZPostViewController
            postVC.assetModel = self.assetModel
        } else if segue.identifier == kSeguePushSocialDetail {
            let detailVC = segue.destination as! WZSocialDetailViewController
            let index = sender as! Int
            detailVC.model = self.socialModels[index]
            detailVC.callBack = { postModel in
                if let model = postModel {
                    self.socialModels[index] = model
                    self.tableView.reloadData()
                }
            }
        }
    }
}
