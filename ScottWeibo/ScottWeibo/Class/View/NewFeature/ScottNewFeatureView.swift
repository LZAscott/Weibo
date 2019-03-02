//
//  ScottNewFeatureView.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/13.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottNewFeatureView: UIView {
    
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    class func newFeatureView() -> ScottNewFeatureView {
        let nib = UINib(nibName: "ScottNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottNewFeatureView
        v.frame = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        
        //设置 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.delegate = self;
    }

    @IBAction func joinBtnClick(_ sender: Any) {
        removeFromSuperview()
    }
}


extension ScottNewFeatureView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        joinBtn.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        pageCtrl.isHidden = (page == scrollView.subviews.count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 滚动到最后一屏，让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        pageCtrl.currentPage = page
        //倒数第二页显示按钮
        joinBtn.isHidden = (page != scrollView.subviews.count - 1)
        
        //判断是否最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
    }
}
