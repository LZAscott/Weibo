//
//  ScottOAuthViewController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScottOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = UIColor.white
        
        title = "登录微博"
        
        setupNaviItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(ScottAppKey)&redirect_uri=\(ScottRedirectURL)"
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    
    /// 关闭按钮点击事件
    @objc fileprivate func closeClick(){
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充点击事件
    @objc fileprivate func autoFillClick(){
        let js = "document.getElementById('userId').value = 'a632845514@vip.qq.com';" + "document.getElementById('passwd').value = 'LI632845514';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    deinit {
        print(#function)
    }
}

extension ScottOAuthViewController:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(#function)
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(ScottRedirectURL) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code") == false {
            closeClick()
            return false
        }
        
        // 截取code
        let code  = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        ScottNetwrokManager.shared.loadAccessToken(code: code){(isSuccess) in
            if isSuccess {
                self.closeClick()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottLoginSuccessNotifacation), object: nil)
            }else{
                SVProgressHUD.showError(withStatus: "网络请求失败")
            }
        }
        
        return false
    }
}


extension ScottOAuthViewController {
    fileprivate func setupNaviItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(closeClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFillClick))
    }
}
