//
//  WZTools.swift
//  Darts
//
//  Created by 马冰垒 on 2020/7/4.
//  Copyright © 2020 毛为哲. All rights reserved.
//

import UIKit

class WZTools: NSObject {
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    /** 登录 */
    class func fetchLoginViewController() -> UIViewController {
        return WZTools.storyboard.instantiateViewController(withIdentifier: "WZLoginViewController")
    }
    /** 主页面 */
    class func fetchRootTabBarViewController() -> UIViewController {
        return WZTools.storyboard.instantiateViewController(withIdentifier: "WZTabBarController")
    }
    /** 首页详情 */
    static let HomeDetailViewController = WZTools.storyboard.instantiateViewController(withIdentifier: "WZSocialDetailViewController")
    /** 发现页 */
    static let DiscoveryDetailViewController = WZTools.storyboard.instantiateViewController(withIdentifier: "WZExploreViewController")
    /** loading 页 */
    static let LoadingViewController = WZTools.storyboard.instantiateViewController(withIdentifier: "DHLoadingViewController")
    class func instantiateViewController(from storyboardName: String?, storyboardId: String) -> UIViewController {
        let sbName = storyboardName ?? "Main"
        let storyboard = UIStoryboard.init(name: sbName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
}
