//
//  WZMakeAppointmentViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/14.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import KFTExtension

class WZMakeAppointmentViewController: WZTableViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var venueNameLabel: UILabel!
    var makeAppointmentSuccessCallback: ((WZAppointmentModel) -> ())?
    var venueModel: WZVenueModel?
    var date = Date.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let datePicker = UIDatePicker.init()
        datePicker.minimumDate = Date.init()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(self.datePickerAction(datePicker:)), for: .valueChanged)
        self.dateTextField.inputView = datePicker
        self.dateTextField.text = KFTDateTool.string(from: date, dateFormat: "yyyy.MM.dd HH:mm")
    }
    
    @objc func datePickerAction(datePicker: UIDatePicker) {
        date = datePicker.date
        self.dateTextField.text = KFTDateTool.string(from: datePicker.date, dateFormat: "yyyy.MM.dd HH:mm")
    }
    
    // MARK: --  UITableViewDelegate --
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "ShowWZVenueViewController", sender: nil)
        }
    }
    
    // MARK: --  Event Response --
    
    /** 发布约战 */
    @IBAction func makeAppointmentButtonAction(_ sender: UIButton) {
        if self.venueModel == nil {
            SVProgressHUD.showError(withStatus: "请选择约战的场馆".localizedString())
            return
        }
        SVProgressHUD.show(withStatus: "发布中...".localizedString())
        let appointment = AVObject.init(className: "Appointment")
        appointment.setObject(AVUser.current(), forKey: "sponsor")
        appointment.setObject(date, forKey: "date")
        if let venueId = venueModel?.venueId {
            let venue = AVObject.init(className: "Venue", objectId: venueId)
            appointment.setObject(venue, forKey: "venue")
        }
        appointment.saveInBackground { (success, error) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "发布约战成功".localizedString())
                if let callback = self.makeAppointmentSuccessCallback {
                    let model = WZAppointmentModel.init(object: appointment)
                    model.venueModel = self.venueModel
                    callback(model)
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZVenueViewController" {
            let venueVC = segue.destination as! WZVenueViewController
            venueVC.isSelectedMode = true
            venueVC.selectedVenueCallback = { venueModel in
                self.venueModel = venueModel
                self.venueNameLabel.text = venueModel.clubName
            }
        }
    }
}
