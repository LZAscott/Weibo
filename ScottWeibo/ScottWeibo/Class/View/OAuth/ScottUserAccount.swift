//
//  ScottUserAccount.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/13.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


private let accountFile:NSString = "userAccount.json"

class ScottUserAccount: NSObject {
    
    /// 访问令牌
    var access_token: String?
    
    /// 用户代号
    var uid: String?
    
    /// access_token 的生命周期 开发者5年 使用者3天
    var expires_in: TimeInterval = 0 {
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name:String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large:String?
    
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        
        // 从磁盘读取账号
        guard let path = accountFile.scott_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
        let dic = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
        else {
            return
        }
        
        yy_modelSet(with: dic ?? [:])
        
        // 判断token是否过期
        if expiresDate?.compare(Date()) == .orderedAscending {
            // 账号过期,清空token
            access_token = nil
            uid = nil
            _ = try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    
    /// 存储账号
    func saveAccount(){
        // 模型转字典
        var dic = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]
        
        // 删除expires_in值
        dic.removeValue(forKey: "expires_in")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
            let filePath = accountFile.scott_appendDocumentDir()
        else {
            return
        }
        
        (data as NSData).write(toFile: filePath, atomically: true)
    }
}
