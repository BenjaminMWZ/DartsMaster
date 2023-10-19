//
//  WZVenueEvaluationViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import QMUIKit
import SVProgressHUD

class WZVenueEvaluationViewController: UIViewController {

    @IBOutlet weak var textView: QMUITextView!
    @IBOutlet weak var contontView: UIView!
    var model: WZVenueModel?
    var starCount: Int = 5
    var callback: ((WZVenueModel, WZEvaluationModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customStarEvaluationUI()
    }
    
    func customStarEvaluationUI() {
        let starView = TggStarEvaluationView.init { (starCount) in
            self.starCount = Int(starCount)
        }
        starView?.starCount = UInt(self.starCount)
        self.contontView.addSubview(starView!)
        starView?.frame = self.contontView.bounds
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        if NSString.isEmpty(self.textView.text) {
            SVProgressHUD.showError(withStatus: "请输入你的评价".localizedString())
            return
        }
        
        let evaluation = AVObject.init(className: "VenueEvaluation")
        if let model = self.model, let venueId = model.venueId {
            evaluation.setObject(venueId, forKey: "venueId")
        }
        evaluation.setObject(AVUser.current(), forKey: "user")
        evaluation.setObject(textView.text, forKey: "content")
        evaluation.setObject(starCount, forKey: "starCount")
        SVProgressHUD.show(withStatus: "发布中...".localizedString())
        evaluation.saveInBackground { (success, error) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "发布成功".localizedString())
                if let model = self.model, let venueId = model.venueId {
                    let totolStarCount = model.starCount * model.evaluationCount + self.starCount
                    model.evaluationCount += 1
                    let newStarCount = round(CGFloat(totolStarCount)/CGFloat(max(model.evaluationCount, 1)))
                    model.starCount = Int(newStarCount)
                    let venue = AVObject.init(className: "Venue", objectId: venueId)
                    venue.incrementKey("evaluationCount", byAmount: 1)
                    venue.setObject(newStarCount, forKey: "starCount")
                    venue.saveInBackground()
                    if let callback = self.callback {
                        let evaluationModel = WZEvaluationModel.init(user: AVUser.current(), content: self.textView.text, starCount: self.starCount, createdAt: evaluation.createdAt)
                        callback(model, evaluationModel)
                    }
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }
        }
    }
}
