//
//  WZWebDetailViewController.swift
//  cooking
//
//  Created by 马冰垒 on 2020/6/28.
//  Copyright © 2020 马冰垒. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WZWebDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var urlString: String?
    var webView = WKWebView.init()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.customWebView()
    }
    
    func customWebView() {
        self.webView.frame = self.view.bounds
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.view.bringSubviewToFront(self.indicatorView)
        self.indicatorView.startAnimating()
        if let urlString = self.urlString {
            if let url = URL.init(string: urlString) {
                let urlRequest = URLRequest.init(url: url)
                self.webView.load(urlRequest)
            }
        }
    }

    // MARK: -- WKUIDelegate --
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
}
