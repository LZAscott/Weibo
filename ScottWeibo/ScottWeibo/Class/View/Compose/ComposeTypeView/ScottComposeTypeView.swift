//
//  ScottComposeTypeView.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/17.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import pop

class ScottComposeTypeView: UIView {
    
    fileprivate var completionBlock:((_ clsName:String?)->())?
    
    @IBOutlet weak var returnCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var closeCenterXCons: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolBar: UIView!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    /// 按钮数据数组
    fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字","clsName": "ScottComposeController"],
                                   ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                                   ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                                   ["imageName": "tabbar_compose_lbs", "title": "签到"],
                                   ["imageName": "tabbar_compose_review", "title": "点评"],
                                   ["imageName": "tabbar_compose_more", "title": "更多","actionName":"moreAction"],
                                   ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                                   ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                                   ["imageName": "tabbar_compose_music", "title": "音乐"],
                                   ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    

    class func composeTypeView() -> ScottComposeTypeView {
        let nib = UINib(nibName: "ScottComposeTypeView", bundle: nil)
        let typeView = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottComposeTypeView
        typeView.frame = UIScreen.main.bounds
        typeView.setupUI()
        return typeView
    }

    
    
    // MARK: 关闭按钮点击
    @IBAction func closeClick() {
        hiddenButtons()
    }
    
    
    
    /// 显示当前视图
    func show(completion:@escaping (_ clsName:String?)->()) {
        
        completionBlock = completion
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        vc.view.addSubview(self)
        showCurrentView()
    }
    
    // MARK: 更多按钮点击
    @objc fileprivate func moreAction(){
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        returnBtn.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        // 关闭按钮位置右移
        closeCenterXCons.constant += margin
        // 返回按钮位置左移
        returnCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25){
            self.layoutIfNeeded()
        }
    }
    
    // MARK: 返回上一页按钮点击
    @IBAction func returnBtnClick() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        closeCenterXCons.constant = 0
        returnCenterXCons.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.returnBtn.alpha = 0
        }, completion: {_ in
            self.returnBtn.isHidden = true
            self.returnBtn.alpha = 1
        })
    }
    
    @objc fileprivate func btnClick(selectBtn:ScottComposeTypeButton){
        
        // 1.获取到当前页
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 2.获取当前view
        let currentView = scrollView.subviews[currentPage]
        
        for (i, btn) in currentView.subviews.enumerated() {
            // 放大选中按钮
            let scaleAnima:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            let scale = (btn == selectBtn ? 2 : 0.2)
            scaleAnima.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnima.duration = 0.5
            btn.pop_add(scaleAnima, forKey: nil)
            
            
            // 渐变动画
            let alphaAnima:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnima.toValue = 0.2
            alphaAnima.duration = 0.5
            btn.pop_add(alphaAnima, forKey: nil)
            
            // 监听动画
            if i == 0 {
                alphaAnima.completionBlock = {_,_ in
                    self.completionBlock?(selectBtn.clsName)
                }
            }
        }
    }
    
    deinit {
        print("ScottComposeTypeView 消失")
    }
}


// MARK: - 处理动画
fileprivate extension ScottComposeTypeView {
    /// 显示当前视图
    func showCurrentView() {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        
        showButtons()
    }
    
    /// 依次显示按钮
    func showButtons() {
        let v = scrollView.subviews[0]
        
        for (i, btn) in v.subviews.enumerated() {
            let anima:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anima.fromValue = btn.center.y + 400
            anima.toValue = btn.center.y
            // 弹性速度 取值范围 0 -20 数值越大，速度越快，默认为12
            anima.springSpeed = 10
            // 弹力系数 取值范围0 - 20 数值越大 弹性越大 默认为4
            anima.springBounciness = 8
            anima.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            btn.pop_add(anima, forKey: nil)
        }
    }
    
    /// 隐藏当前视图
    func hiddenCurrentView() {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = {_,_ in
            self.removeFromSuperview()
        }
    }
    
    /// 依次隐藏按钮
    func hiddenButtons() {
        // 1.获取到当前页
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 2.获取当前view
        let currentView = scrollView.subviews[currentPage]
        
        // 3.依次隐藏当前view上的按钮
        for (i, btn) in currentView.subviews.enumerated() {
            
            let anima:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anima.fromValue = btn.center.y
            anima.toValue = btn.center.y + 400
            
            anima.beginTime = CACurrentMediaTime() + CFTimeInterval(currentView.subviews.count - i) * 0.025
            btn.pop_add(anima, forKey: nil)
            if i == 0 {
                anima.completionBlock = {_,_ in
                    self.hiddenCurrentView()
                }
            }
        }
    }
}


// MARK: - 设置界面
fileprivate extension ScottComposeTypeView {
    
    fileprivate func setupUI(){
        layoutIfNeeded()
        
        let rect = scrollView.bounds
        
        // 向scrollView添加视图
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0))
            addBtns(view: v, index: i * 6)
            scrollView.addSubview(v)
        }
        
        scrollView.contentSize = CGSize(width: 2 * rect.width, height: rect.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
    }
    
    
    // MARK: 添加按钮
    private func addBtns(view:UIView, index:Int){
        
        let count = 6
        
        for i in index..<(index+count) {
            if i >= buttonsInfo.count {
                break
            }
            
            let dict = buttonsInfo[i]
            
            guard let imgName = dict["imageName"],
                let title = dict["title"]
            else {
                continue
            }
            
            
            let btn = ScottComposeTypeButton.compeTypeButton(imageName: imgName, title: title)
            view.addSubview(btn)
            
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else{
                btn.addTarget(self, action: #selector(btnClick(selectBtn:)), for: .touchUpInside)
            }

            btn.clsName = dict["clsName"]
        }
        
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (view.bounds.width - 3 * btnSize.width) / 4
        
        for (i,btn) in view.subviews.enumerated() {
            let x = margin + CGFloat(i % 3) * (btnSize.width + margin)
            let y = (i > 2) ? (view.bounds.height - btnSize.height) : 0
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
}
