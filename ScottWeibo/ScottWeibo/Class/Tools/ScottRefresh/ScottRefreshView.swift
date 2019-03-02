//
//  ScottRefreshView.swift
//  RefreshDemo
//
//  Created by bopeng on 2017/1/17.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottRefreshView: UIView {
    
    var refreshStatus:ScottRefreshStatus = .Normal {
        didSet{
            switch refreshStatus {
            case .Normal:
                textLabel?.text = "继续使劲拉"
                tipIcon?.isHidden = false
                tipIndicator?.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon?.transform = CGAffineTransform.identity
                })
            case .Pulling:
                textLabel?.text = "松手就刷新"
                tipIcon?.isHidden = false
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.0001))
                })
                
            case .WillRefresh:
                textLabel?.text = "正在刷新"
                tipIcon?.isHidden = true
                tipIndicator?.startAnimating()
            }
        }
    }
    

    /// 提示文字
    @IBOutlet weak var textLabel: UILabel?
    /// 指示图标
    @IBOutlet weak var tipIcon: UIImageView?
    /// 指示器
    @IBOutlet weak var tipIndicator: UIActivityIndicatorView?
    
    
    
    /// 父视图高度 (为了给ScottCTRefreshView写缩放用的)
    var parentHeight:CGFloat = 0
    
    
    class func refreshView() -> ScottRefreshView {
        let nib = UINib(nibName: "ScottCTRefreshView", bundle: nil)
        let refreshV = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottRefreshView
        refreshV.refreshStatus = .Normal
        return refreshV
    }
}
