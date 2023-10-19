//
//  WZVenueDetailViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import SDCycleScrollView

class WZVenueDetailViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var model: WZVenueModel?
    let query = AVQuery.init(className: "VenueEvaluation")
    var evaluationModels: [WZEvaluationModel] = []
    var pageNumer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.customHeaderView()
        if model?.venueId != nil {
            self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
                self.loadVenueEvaluation()
            })
            self.tableView.mj_footer?.isAutomaticallyChangeAlpha = true
            self.tableView.mj_footer?.beginRefreshing()
        }
    }
    
    func customHeaderView() {
        let cycleScrollView = SDCycleScrollView.init()
        self.headerContentView.addSubview(cycleScrollView)
        cycleScrollView.translatesAutoresizingMaskIntoConstraints = false
        cycleScrollView.leadingAnchor.constraint(equalTo: self.headerContentView.leadingAnchor, constant: 0).isActive = true
        cycleScrollView.trailingAnchor.constraint(equalTo: self.headerContentView.trailingAnchor, constant: 0).isActive = true
        cycleScrollView.topAnchor.constraint(equalTo: self.headerContentView.topAnchor, constant: 0).isActive = true
        cycleScrollView.bottomAnchor.constraint(equalTo: self.headerContentView.bottomAnchor, constant: 0).isActive = true
        cycleScrollView.placeholderImage = UIImage.init(named: "icon_banner_placeholder")
        cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        if let model = self.model {
            titleLabel.text = model.clubName
            priceLabel.text = "￥\(model.price)"
            phoneNumberLabel.text = model.phoneNumber
            addressLabel.text = model.address
            cycleScrollView.imageURLStringsGroup = model.imageUrls
        }
    }
    
    func loadVenueEvaluation() {
        if let venueId = model?.venueId {
            query.addDescendingOrder("createdAt")
            query.whereKey("venueId", equalTo: venueId)
            query.includeKey("user")
            query.limit = kPageSize
            query.skip = pageNumer * kPageSize
            query.cachePolicy = .networkElseCache
            query.findObjectsInBackground { (result, error) in
                self.tableView.mj_footer?.endRefreshing()
                if let data = result as? [AVObject] {
                    if data.count < kPageSize {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer?.resetNoMoreData()
                    }
                    if data.count > 0 {
                        for obj in data {
                            let model = WZEvaluationModel.init(object: obj)
                            self.evaluationModels.append(model)
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluationModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WZVenueCommentCell", for: indexPath) as! WZVenueCommentCell
        cell.model = evaluationModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: -----------------  UICollectionViewDataSource -----------------

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZDartsStarItemCell", for: indexPath) as! WZDartsStarItemCell
        if indexPath.item < self.model?.starCount ?? 0 {
            cell.imageView.image = UIImage.init(named: "icon_star")
        } else {
            cell.imageView.image = UIImage.init(named: "icon_star_grey")
        }
        return cell
    }
    
    // MARK: --  Event Response --

    @IBAction func evaluationButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowWZVenueEvaluationViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWZVenueEvaluationViewController" {
            let venueEvaluationVC = segue.destination as? WZVenueEvaluationViewController
            venueEvaluationVC?.model = self.model
            venueEvaluationVC?.callback = { (venueModel, evaluationModel) in
                self.model = venueModel
                self.evaluationModels.insert(evaluationModel, at: 0)
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
}
