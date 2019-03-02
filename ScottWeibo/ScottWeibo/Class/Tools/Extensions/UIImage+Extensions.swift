//
//  UIImage+Extensions.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scott_avatarImage(size:CGSize?, backColor:UIColor = UIColor.white, lineColor:UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1.开启上下文
        UIGraphicsBeginImageContextWithOptions(size!, true, 0)
        
        // 2.绘制图像
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2.0
        lineColor.setStroke()
        ovalPath.stroke()
        
        // 3.取出图像
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        // 5.返回结果
        return result
    }
}
