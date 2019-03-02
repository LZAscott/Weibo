//
//  ScottVisitorView.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottVisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    var visitorInfoDic:[String:String]? {
        didSet{
            guard let imageName = visitorInfoDic?["imageName"],
                let message = visitorInfoDic?["message"]  else {
                return
            }
            
            // 设置提示文字
            tipsLabel.text = message
            
            if imageName.isEmpty { // 如果是空的，就是默认的首页
                // 开始动画
                startAnimation()
                return
            }
            
            // 设置houseIconView
            houseIconView.image = UIImage(named: imageName)
            
            // 隐藏maskView
            maskIconView.isHidden = true
            // 隐藏小转轮
            iconView.isHidden = true
        }
    }
    
    
    /// 转动动画
    private func startAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        animation.duration = 15
        animation.isRemovedOnCompletion = false
        iconView.layer.add(animation, forKey: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 懒加载
    // 小转轮
    fileprivate lazy var iconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // 小房子
    fileprivate lazy var houseIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // 提示文字
    fileprivate lazy var tipsLabel:UILabel = UILabel.scott_label(withText: "关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    // 注册
    lazy var registerBtn:UIButton = UIButton.scott_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    // 登录
    lazy var loginBtn:UIButton = UIButton.scott_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    // 遮罩视图
    fileprivate lazy var maskIconView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
}


// MARK: - 设置界面
extension ScottVisitorView {
    fileprivate func setupUI(){
        backgroundColor = UIColor.scott_color(withHex: 0xEDEDED)
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipsLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        tipsLabel.textAlignment = .center
        
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let margin:CGFloat = 20
        
        // 小转轮
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -50))
        
        // 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView, attribute: .centerY, relatedBy: .equal, toItem: iconView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        // 提示文字
        addConstraint(NSLayoutConstraint(item: tipsLabel, attribute: .centerX, relatedBy: .equal, toItem: iconView, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipsLabel, attribute: .top, relatedBy: .equal, toItem: iconView, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: tipsLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 236))
        
        // 注册按钮
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .left, relatedBy: .equal, toItem: tipsLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .top, relatedBy: .equal, toItem: tipsLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        
        // 登录按钮
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .right, relatedBy: .equal, toItem: tipsLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: tipsLabel, attribute: .bottom, multiplier: 1.0, constant: margin))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: registerBtn, attribute: .width, multiplier: 1.0, constant: 0))
        
        // 遮罩视图
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: maskIconView, attribute: .bottom, relatedBy: .equal, toItem: registerBtn, attribute: .top, multiplier: 1.0, constant: -margin))
    }
}
