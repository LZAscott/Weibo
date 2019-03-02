//
//  ScottWebViewController.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/22.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScottWebViewController: ScottBaseController {
    
    fileprivate lazy var webView:UIWebView = {
        let webView = UIWebView(frame: UIScreen.main.bounds)
        webView.isOpaque = false
        webView.delegate = self
        return webView
    }()

    var urlString:String? {
        didSet {
            guard let urlString = urlString,
                let url = URL(string: urlString)
            else {
                return
            }
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        
        SVProgressHUD.dismiss()
        print("网页消失")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ScottWebViewController {
    override func setupTableView() {
        navigationItem.title = "网页"
        
        view.insertSubview(webView, belowSubview: scottNaviBar)
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        webView.scrollView.contentInset.top = scottNaviBar.bounds.height
    }
}

extension ScottWebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}
