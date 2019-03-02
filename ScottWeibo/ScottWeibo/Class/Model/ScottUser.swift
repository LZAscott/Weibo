//
//  ScottUser.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


/// 微博用户模型
class ScottUser: NSObject {
    
    /// 用户UID
    var id:Int64 = 0
    
    /// 用户昵称
    var screen_name:String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url:String?
    
    /// 认证类型：-1：没有认证， 0：认证用户， 2，3，5：企业认证， 220：达人
    var verified_type:Int = 0
    
    /// 会员等级0-6
    var mbrank:Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
