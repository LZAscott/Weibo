//
//  ScottStatusPicView.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottStatusPicView: UIView {
    
    @IBOutlet weak var heightCons:NSLayoutConstraint!
    
    var viewModel:ScottStatusViewModel? {
        didSet{
            // 设置配图
            urls = viewModel?.picURLs
            
            caculateViewSize()
        }
    }
    
    // 处理只有一张图片的情况下，更改imageView的尺寸
    private func caculateViewSize(){
        
        // 处理宽度
        if viewModel?.picURLs?.count == 1 { // a> 单图
            let viewSize = viewModel?.picViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: ScottStatusPicViewOuterMargin, width: viewSize.width, height: viewSize.height - ScottStatusPicViewOuterMargin)
        }else{ // b> 多图 || 无图
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: ScottStatusPicViewOuterMargin, width: ScottStatusItemWidth, height: ScottStatusItemWidth)
        }
        
        
        /// 配图视图大小
        heightCons.constant = viewModel?.picViewSize.height ?? 0
    }

    private var urls:[ScottStatusPicture]? {
        didSet{
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                
                let iv = subviews[index] as! UIImageView
                
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                iv.scott_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                iv.isHidden = false
                index += 1
            }
        }
    }
    
    override func awakeFromNib() {
        setupUI()
    }
}


extension ScottStatusPicView {
    
    /// 设置UI
    fileprivate func setupUI(){
        
        backgroundColor = superview?.backgroundColor
        
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: ScottStatusPicViewOuterMargin, width: ScottStatusItemWidth, height: ScottStatusItemWidth)
        
        for i in 0..<count * count {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            let xOffset = col * (ScottStatusPicViewInnerMargin + ScottStatusItemWidth)
            let yOffset = row * (ScottStatusPicViewInnerMargin + ScottStatusItemWidth)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
        }
    }
}
