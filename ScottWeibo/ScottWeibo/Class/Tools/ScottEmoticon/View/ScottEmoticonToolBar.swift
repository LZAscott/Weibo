//
//  ScottEmoticonToolBar.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/23.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottEmoticonToolBar: UIView {

    override func awakeFromNib() {
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 布局所有按钮
        let count = subviews.count
        let w = bounds.width / CGFloat(count)
        
        let rect = CGRect(x: 0, y: 0, width: w, height: bounds.height)
        for (i,btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * w, dy: 0)
        }
    }
}


fileprivate extension ScottEmoticonToolBar {
    
    func setupUI() {
        let manager = ScottEmoticonManager.shared
        
        // 1.获取表情包
        for p in manager.packages {
            let btn = UIButton(type: .custom)
            btn.setTitle(p.groupName, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            
            
            let imageName = "compose_emotion_table_\(p.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(p.bgImageName ?? "")_selected"
            
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
            
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(imageHL, for: .selected)
            btn.setBackgroundImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            addSubview(btn)
        }
    }
}
