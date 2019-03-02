//
//  AppDelegate.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = ScottTabBarController()
        window?.makeKeyAndVisible()
        
        setupAdditions()
        loadAppInfo()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}


// MARK: - 设置额外信息
extension AppDelegate {
    fileprivate func setupAdditions() {
        // 设置SVProgressHUD的最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        // 设置网络时的加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound, .carPlay], completionHandler: {(success,error) in
                
                if !success {
                    SVProgressHUD.showInfo(withStatus: "用户授权通知\(error)")
                }
            })
        }else{
            let notifiSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifiSettings)
        }
    }
}

// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    fileprivate func loadAppInfo(){
        DispatchQueue.global().async {
            // 1. url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            // 2. data
            let data = NSData(contentsOf: url!)
            
            // 3. 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}
