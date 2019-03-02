//
//  ScottComposeTextView.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/18.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottComposeTextView: UITextView {
    
    fileprivate lazy var placeholderLabel = UILabel()

    override func awakeFromNib() {
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: Notification.Name.UITextViewTextDidChange, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textChanged(){
        placeholderLabel.isHidden = hasText
    }
}


fileprivate extension ScottComposeTextView {
    func setupUI() {
        //1.设置占位标签
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
    }
}
