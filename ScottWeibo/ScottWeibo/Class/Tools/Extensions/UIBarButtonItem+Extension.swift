//
//  UIBarButtonItem+Extension.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    
    /// 创建UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: title字体大小，默认16
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否是返回按钮，默认不是
    convenience init(title:String, fontSize:CGFloat = 16, target:AnyObject, action:Selector, isBack:Bool = false) {
        let btn:UIButton = UIButton.scott_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        let img = "navigationbar_back_withtext"
        
        if isBack {
            
            btn.setImage(UIImage(named: img), for: .normal)
            btn.setImage(UIImage(named: img + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView:btn)
    }
}
