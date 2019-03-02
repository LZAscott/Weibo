//
//  ScottEmoticon.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import YYModel


class ScottEmoticon: NSObject {
    
    /// false是图片表情，true是emoji
    var type = false
    
    /// 表情字符串，发送给服务器(节约流量)
    var chs:String?
    
    /// 表情图片名称，用户图文混排
    var png:String?
    
    /// emoji的十六进制编码
    var code:String?
    
    /// 表情所在的目录文件
    var directory:String?
    
    /// 图片表情对应的图像
    var image:UIImage? {
        if type {
            return nil
        }

        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "ScottEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
        else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    func attributedText(font:UIFont) -> NSAttributedString {
        
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attachment = NSTextAttachment()
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        return NSAttributedString(attachment: attachment)
    }
    
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
