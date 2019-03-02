//
//  ScottStatus.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import YYModel

class ScottStatus: NSObject {
    
    /// Int64类型
    var id:Int64 = 0

    /// 微博信息内容
    var text:String?
    
    /// 用户类
    var user:ScottUser?
    
    /// 微博创建时间
    var created_at:String?
    
    /// 微博来源
    var source:String?{
        didSet {
            ///设置微博来源
            if let text = source?.scott_href()?.text {
                source = "来自" + text
            } else {
                source = ""
            }
        }
    }
    
    /// 转发数
    var reposts_count:Int = 0
    
    /// 评论数
    var comments_count:Int = 0
    
    /// 表态数
    var attitudes_count:Int = 0
    
    /// 图片链接数组
    var pic_urls:[ScottStatusPicture]?
    
    /// 转发微博
    var retweeted_status:ScottStatus?
    
    class func modelContainerPropertyGenericClass() -> [String:AnyClass] {
        return ["pic_urls" : ScottStatusPicture.self]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
