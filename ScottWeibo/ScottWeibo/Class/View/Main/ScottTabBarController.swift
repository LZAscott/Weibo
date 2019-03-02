//
//  ScottTabBarController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScottTabBarController: UITabBarController {
    
    // MARK: - 私有控件 撰写按钮
    fileprivate lazy var composeBtn:UIButton = UIButton.scott_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    // 定时器
    fileprivate var time:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        setupComposeBtn()
        setupNewFeature()
        setupTimer()
        
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoginClick(noti:)), name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: nil)
    }
    
    /// 弹出登录框
    @objc fileprivate func userLoginClick(noti:Notification){
        var deadLineTime = DispatchTime.now()
        
        if noti.object != nil { // token过期
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录过时，需要重新登录")
            deadLineTime = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadLineTime, execute: {
            SVProgressHUD.setDefaultMaskType(.clear)
            //展现登录控制器
            let nvc = UINavigationController(rootViewController: ScottOAuthViewController())
            self.present(nvc, animated: true, completion: nil)
        })
    }
    
    /// 点击撰写按钮
    @objc fileprivate func composeBtnClick(){
        if ScottNetwrokManager.shared.userLogin == false {  // 未登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: nil)
            return
        }
        
        // 1.实例化视图
        let composeTypeView = ScottComposeTypeView.composeTypeView()
        
        // 2.显示视图
        composeTypeView.show { [weak composeTypeView](clsName) in
            // 2.1 拼接当前类名
            guard let clsName = clsName,
                let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else{
                composeTypeView?.removeFromSuperview()
                return
            }
            
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: { 
                composeTypeView?.removeFromSuperview()
            })
        }
    }
    
    deinit {
        time?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ScottTabBarController:UITabBarControllerDelegate {
    
    /// 将要选择tabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = childViewControllers.index(of: viewController)
        
        if selectedIndex == 0 && index == selectedIndex {   // 当前处于首页，且点击的首页item
            // 1. 回到顶部
            
            let nav = childViewControllers[0] as! ScottNavigationController
            let vc = nav.childViewControllers[0] as! ScottHomeController
            
            vc.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            vc.refreshCtrl?.beginRefreshing()
        }
        
        // 如果是UIViewController这个类，就不加载(主要是为了防止点击撰写按钮)
        return !viewController.isMember(of: UIViewController.self)
    }
}


// MARK: - 定时器相关
extension ScottTabBarController {
    fileprivate func setupTimer(){
        time = Timer.scheduledTimer(timeInterval: 240.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(time!, forMode: .commonModes)
    }
    
    @objc fileprivate func updateTimer(){
        if !ScottNetwrokManager.shared.userLogin {
            return
        }
        
        ScottNetwrokManager.shared.loadUnreadCount(completion: {(count) in
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            //设置 App的badgeNumber 从ios 8.0 之后 需要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = count
        })
    }
}


// MARK: - 新特性界面
extension ScottTabBarController {
    
    fileprivate func setupNewFeature(){
        // 1.判断是否登录
        if !ScottNetwrokManager.shared.userLogin {   // 没有登录
            return
        }
        
        // 2.已经登录的情况
        // 2.1 判断显示新版本介绍还是欢迎页
        let v = isNewVersion ? ScottNewFeatureView.newFeatureView() : ScottWelcomView.welcomView()
        view.addSubview(v)
    }
    
    
    
    /// 计算性属性
    private var isNewVersion:Bool {
        // 1.取出当前版本
        let currenVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

        // 2.取沙盒版本
        let beforeVersion = UserDefaults.standard.string(forKey: "ScottVersionKey") ?? ""
        
        // 3.更新沙盒版本
        UserDefaults.standard.set(currenVersion, forKey: "ScottVersionKey")
        
        // 4.判断两个版本是否一致
        return currenVersion != beforeVersion
    }
}


// MARK: - 添加子控件
extension ScottTabBarController {
    
    /// MARK: 添加子控制器
    fileprivate func setupControllers(){
        
        // 获取沙盒json路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断data是否存在，如果不存在就说明沙盒没有文件,那就加载本地Bundle文件
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        
        /*
         try? -- 如果解析成功就有值，否则为nil
         try! -- 如果解析成功就有值，否则奔溃
         try  -- do { let array = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:Any]] } catch{ print(error) }
         */
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:Any]]
            else {
            return
        }
        
        var viewControllersArray = [UIViewController]()
        for dic in array! {
            viewControllersArray.append(childViewController(dic: dic))
        }
        viewControllers = viewControllersArray
    }
    
    
    /// MARK: 添加单独的子控制器
    private func childViewController(dic:[String:Any]) -> UIViewController {
        // 1.取字典内容
        guard let clsName = dic["clsName"] as? String,
            let title = dic["title"] as? String,
            let imageName = dic["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? ScottBaseController.Type,
            let visitorInfoDic = dic["visitorInfo"] as? [String:String]
            else {
                return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.visitorInfoDic = visitorInfoDic
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.tintColor = UIColor.orange
        
        //修改 tabbar 的标题前景色
//        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for:.highlighted)
        //修改字体 系统默认是12号
//        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: .normal)
        
        let nav = ScottNavigationController(rootViewController: vc)
        return nav
    }

    
    fileprivate func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count
        
        composeBtn.frame = tabBar.bounds.insetBy(dx: width * 2, dy: 0)
        
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
    }
    
    /**
     portrait :竖屏，肖像
     landscape : 横屏，风景画
     
     - 使用代码控制方向之后 好处 可以在横屏的时候 单独处理
     - 设置支持方向之后 当前的控制器及子控制器都会遵守这个方向
     - 如果播放视频 通常是通过 modal 展现的 present
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


