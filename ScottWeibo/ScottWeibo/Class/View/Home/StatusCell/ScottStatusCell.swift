//
//  ScottStatusCell.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

@objc protocol ScottStatusCellDelegate:NSObjectProtocol {
    @objc optional func scottStatusCellDidSelectedURLString(cell:ScottStatusCell, urlString:String)
}

class ScottStatusCell: UITableViewCell {
    
    /// 代理属性
    weak var delegate:ScottStatusCellDelegate?
    
    var viewModel:ScottStatusViewModel? {
        didSet{

            /// 设置头像
            iconView.scott_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            
            /// 昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            if (viewModel?.status.user?.mbrank)! > 0 && (viewModel?.status.user?.mbrank)! < 7 {
                nameLabel.textColor = UIColor.scott_color(withHex: 0xFC3E00)
                
            } else {
                nameLabel.textColor = UIColor.scott_color(withHex: 0x555555)
            }
            
            
            /// 会员
            memberIconView.image = viewModel?.memberIcon
            
            /// 时间
            timeLabel.text = viewModel?.createTime
            
            
            /// 来源
            sourceLabel.text = viewModel?.status.source
            
            /// 内容
            statusLabel?.attributedText = viewModel?.statusAttrText
            
            /// 认证图标
            vipIconView.image = viewModel?.vipIcon
            
            /// 底部工具栏
            toolBar.viewModel = viewModel
            
            /// 传递视图模型
            pictureView.viewModel = viewModel
            
            /// 被转发微博原文
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
        }
    }
    
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员
    @IBOutlet weak var memberIconView: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证
    @IBOutlet weak var vipIconView: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLabel: ScottLabel!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: ScottStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: ScottStatusPicView!
    
    /// 被转发微博原文
    @IBOutlet weak var retweetedLabel: ScottLabel?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 离屏渲染
        /*
         *  离屏渲染需要在CPU/GPU直接快速切换
         */
        layer.drawsAsynchronously = true
        
        /// 栅栏化（注意：使用栅格化一定要指定分辨率）
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }
}


extension ScottStatusCell:ScottLabelDelegate {
    func labelDidSelectedLinkText(label: ScottLabel, text: String) {
        delegate?.scottStatusCellDidSelectedURLString?(cell:self, urlString:text)
    }
}
