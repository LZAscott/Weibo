//
//  ScottBaseController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import MJRefresh

class ScottBaseController: UIViewController {
    
    // 访客视图信息字典
    var visitorInfoDic:[String:String]?

    lazy var scottNaviBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
    lazy var scottNaviItem = UINavigationItem()
    
    var tableView:UITableView?
    
    var refreshCtrl:MJRefreshNormalHeader?
    
    var isPullup:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        ScottNetwrokManager.shared.userLogin ? refreshCtrl?.beginRefreshing() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(notifi:)), name: NSNotification.Name(rawValue: ScottLoginSuccessNotifacation), object: nil)
    }
    
    func loadData() {
        refreshCtrl?.endRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ScottLoginSuccessNotifacation), object: nil)
    }
    
    override var title: String? {
        didSet {
            scottNaviItem.title = title ?? ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - 监听注册和登录按钮
extension ScottBaseController {
    
    
    // MARK: 登录成功的通知
    @objc fileprivate func loginSuccess(notifi:Notification){
        scottNaviItem.leftBarButtonItem = nil
        scottNaviItem.rightBarButtonItem = nil
        
        view = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: 注册按钮点击事件
    @objc fileprivate func registerBtnClick(){
        print(#function)
    }
    
    // MARK: 登录按钮点击事件
    @objc fileprivate func loginBtnClick(){
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: nil)
    }
}

// MARK: - 设置界面
extension ScottBaseController {
    fileprivate func setupUI(){
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        ScottNetwrokManager.shared.userLogin ? setupTableView() : setupVisitorView()
    }
    
    
    /// 设置tableView
    func setupTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableView!, belowSubview: scottNaviBar)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.contentInset = UIEdgeInsets(top: scottNaviBar.scott_height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        addRefreshControl()
    }
    
    func addRefreshControl() {
//        refreshCtrl = MJRefreshHeader()
//        tableView?.addSubview(refreshCtrl!)
//        refreshCtrl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        refreshCtrl = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        refreshCtrl?.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = refreshCtrl
    }
    
    /// 设置访客视图
    private func setupVisitorView(){
        let visitorView = ScottVisitorView(frame: view.bounds)
        visitorView.visitorInfoDic = visitorInfoDic
        view.insertSubview(visitorView, belowSubview: scottNaviBar)
        
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        
        scottNaviItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        scottNaviItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
    
    
    /// MARK:设置导航栏
    private func setupNavigationBar(){
        view.addSubview(scottNaviBar)
        
        //将item 设置给bar
        scottNaviBar.items = [scottNaviItem]
        //设置 navBar 的渲染颜色
        scottNaviBar.barTintColor = UIColor.scott_color(withHex: 0xF6F6F6)
        //设置navBar 的标题字体颜色
        scottNaviBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //设置系统按钮的文字渲染颜色  只对系统.plain 的方法有效
        scottNaviBar.tintColor = UIColor.orange
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScottBaseController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        // 取出最大的section的最后一行
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let rowCount = tableView.numberOfRows(inSection: section)
        
        if row == rowCount - 1 && !isPullup {
            isPullup = true
            loadData()
        }
    }
}
