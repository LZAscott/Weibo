//
//  ScottNavigationController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隐藏默认的导航栏
        navigationBar.isHidden = true
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            //一层显示首页标题 其他显示返回
            if let vc = (viewController as? ScottBaseController){
                var title = "返回"
                
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                vc.scottNaviItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent),isBack:true)
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popToParent(){
        popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
