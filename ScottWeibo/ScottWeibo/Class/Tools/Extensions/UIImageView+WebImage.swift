//
//  UIImageView+WebImage.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    /// 隔离SDWebImage设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 占位图像
    ///   - isAvatar: 是否头像
    func scott_setImage(urlString:String?, placeholderImage:UIImage?, isAvatar:Bool = false) {
        guard let urlString = urlString,
            let url = URL(string:urlString)
        else {
            image = placeholderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil){[weak self](image,_,_,_) in
            if isAvatar {
                self?.image = image?.scott_avatarImage(size: self?.bounds.size)
            }
        }
    }
}
