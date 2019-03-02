//
//  ScottStatusToolBar.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottStatusToolBar: UIView {

    var viewModel:ScottStatusViewModel? {
        didSet{
            retweetBtn.setTitle(viewModel?.retweetedStr, for: .normal)
            commentBtn.setTitle(viewModel?.commentStr, for: .normal)
            likeBtn.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetBtn:UIButton!
    
    /// 评论
    @IBOutlet weak var commentBtn:UIButton!
    
    /// 赞
    @IBOutlet weak var likeBtn:UIButton!
}
