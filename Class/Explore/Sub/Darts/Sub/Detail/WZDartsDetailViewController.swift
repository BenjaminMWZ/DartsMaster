//
//  WZDartsDetailViewController.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/13.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import SDCycleScrollView

class WZDartsDetailViewController: WZTableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var headerView: UIView!
    /** 标题 */
    @IBOutlet weak var titleLabel: UILabel!
    /** 价格 */
    @IBOutlet weak var priceLabel: UILabel!
    /** 材质 */
    @IBOutlet weak var materialLabel: UILabel!
    /** 重量 */
    @IBOutlet weak var weightLabel: UILabel!
    /** 外观 */
    @IBOutlet weak var looksLabel: UILabel!
    /** 推荐星级 */
    @IBOutlet weak var collectionView: UICollectionView!
    /** 测评语 */
    @IBOutlet weak var introduceLabel: UILabel!
    
    var model: WZDartsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.customHeaderView()
    }
    
    func customHeaderView() {
        let cycleScrollView = SDCycleScrollView.init()
        self.headerView.addSubview(cycleScrollView)
        cycleScrollView.translatesAutoresizingMaskIntoConstraints = false
        cycleScrollView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 0).isActive = true
        cycleScrollView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: 0).isActive = true
        cycleScrollView.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 0).isActive = true
        cycleScrollView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0).isActive = true
        cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        cycleScrollView.placeholderImage = UIImage.init(named: "icon_banner_placeholder")
        if let model = self.model {
            if let imageUrls = model.imageUrls {
                cycleScrollView.imageURLStringsGroup = imageUrls
            }
            titleLabel.text = model.name
            priceLabel.text = "￥\(model.price ?? 0)"
            materialLabel.text = model.material
            weightLabel.text = "\(model.weight ?? 0)g"
            looksLabel.text = model.look
            introduceLabel.text = model.evaluation
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: -----------------  UICollectionViewDataSource -----------------

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WZDartsStarItemCell", for: indexPath) as! WZDartsStarItemCell
        if indexPath.item < model?.starCount ?? 1 {
            cell.imageView.image = UIImage.init(named: "icon_star")
        } else {
            cell.imageView.image = UIImage.init(named: "icon_star_grey")
        }
        return cell
    }
}
