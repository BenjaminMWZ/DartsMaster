//
//  WZAppointmentDetailController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZAppointmentDetailController: WZTableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /** 约战日期 */
    @IBOutlet weak var dateLabel: UILabel!
    /** 场馆名称 */
    @IBOutlet weak var clubNameLabel: UILabel!
    /** 应战的人 */
    @IBOutlet weak var collectionView: UICollectionView!
    /** 应战人列表高度 */
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    /** 应战 button */
    @IBOutlet weak var acceptButton: WZRoundCornerButton!
    var acceptSuccessCallback: ((WZAppointmentModel) -> ())?
    var model: WZAppointmentModel?
    var rowCount = 6.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        loadData()
    }
    
    func loadData() {
        if let model = model {
            if let currentUser = AVUser.current() {
                if model.sponsor == currentUser || model.acceptedUsers.contains(currentUser) {
                    self.acceptButton.isHidden = true
                }
            }
            if let date = model.date {
                dateLabel.text = KFTDateTool.string(from: date, dateFormat: "yyyy.MM.dd HH:mm")
                // 约战日期小于当前日期时, 不可应战
                if date.compare(Date.init()) == .orderedAscending {
                    self.acceptButton.isHidden = true
                }
            }
            clubNameLabel.text = model.venueModel?.clubName
            self.caculateCollectionViewHeight()
        }
    }
    
    func caculateCollectionViewHeight() {
        let space = 5.0
        self.layout.minimumInteritemSpacing = CGFloat(space)
        self.layout.minimumLineSpacing = CGFloat(space)
        let collectionViewWidth = self.collectionView.bounds.width
        let cellWidth = (Double(collectionViewWidth) - (rowCount - 1) * space)/rowCount
        self.layout.itemSize = CGSize.init(width: cellWidth, height: cellWidth)
        let lineCount = ceil(Double(max(model?.acceptedUsers.count ?? 1, 1))/rowCount)
        self.collectionViewHeight.constant = CGFloat(lineCount * cellWidth + (lineCount - 1) * space)
    }

    // MARK: --  Event Response --
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        if let appointmentId = model?.appointmentId, var users = model?.acceptedUsers, let currentUser = AVUser.current() {
            let appointment = AVObject.init(className: "Appointment", objectId: appointmentId)
            if users.contains(currentUser) {
                users = users.filter({ (user) -> Bool in
                    return user != currentUser
                })
            }
            users.append(currentUser)
            appointment.addObjects(from: users, forKey: "acceptedUsers")
            SVProgressHUD.show()
            appointment.saveInBackground { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "您已应战, 准备亮镖吧, 少年".localizedString())
                    if let callback = self.acceptSuccessCallback {
                        self.model?.acceptedUsers = users
                        callback(self.model!)
                    }
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "数据错误, 请稍后再试")
        }
    }
    
    // MARK: --  UITableViewDelegate --
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 { // 场馆详情
            self.performSegue(withIdentifier: "ShowWZVenueDetailViewController", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return UITableView.automaticDimension
        }
        return 44
    }
    
    // MARK: --  UICollectionViewDataSource --
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.acceptedUsers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZAcceptUserCell", for: indexPath) as! WZAcceptUserCell
        cell.user = model?.acceptedUsers[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZVenueDetailViewController" {
            let detailVC = segue.destination as? WZVenueDetailViewController
            detailVC?.model = model?.venueModel
            
        }
    }
}
