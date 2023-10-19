//
//  WZExtension.swift
//  Darts
//
//  Created by 马冰垒 on 2020/5/28.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit
import KFTExtension

extension UIColor {
    static let themeColor = UIColor.init(hexString: "F33845")
}

extension UIImage {
    static let defaultHeadImage = UIImage.init(named: "icon_headImage")
}

extension UIImageView {
    func wz_setImage(urlString: String?, placeHolderImage: UIImage?) {
        self.sd_setImage(with: URL.init(string: urlString ?? ""), placeholderImage: placeHolderImage)
    }
}

extension String {
    func localizedString() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

let kLeancloudAppId = "GebzipfmDEYePnh8Lj1MoAMj-MdYXbMMI"
let kLeancloudAppKey = "mEfLazzYVwjYxQrxIeiTtWmJ"
let kPageSize = 10
