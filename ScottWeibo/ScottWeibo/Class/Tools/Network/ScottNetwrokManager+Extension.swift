//
//  ScottNetwrokManager+Extension.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation
import YYModel

private let HttpRootURL = "https://api.weibo.com/"

// MARK: - 封装新浪微博的网络请求
extension ScottNetwrokManager {
    /// 加载微博数据
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion:@escaping (_ list:[[String:AnyObject]]?, _ isSuccess:Bool)->()) {
        let urlString = HttpRootURL + "2/statuses/home_timeline.json"
        
        let params = ["since_id":since_id, "max_id":max_id > 0 ? max_id - 1 : 0]
        
        
        tokenRequest(URLString: urlString, parameters: params as [String:AnyObject]?, completion: {(json, isSuccess) in
            let result = json?["statuses"] as? [[String:AnyObject]]
            
            completion(result, isSuccess)
        })
    }
}


// MARK: - 微博的未读数量
extension ScottNetwrokManager {
    func loadUnreadCount(completion:@escaping (_ count:Int)->()) {
        guard let userId = self.userAccount.uid else {
            return
        }
        
        let urlStr = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":userId]
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]?, completion: {(json, isSuccess)in
            let dic = json as? [String: AnyObject]
            let unreadCount = dic?["status"] as? Int
            completion(unreadCount ?? 0)
        })
    }
}


// MARK: - 发送微博
extension ScottNetwrokManager {
    func postStatus(text:String, image:UIImage?, completion:@escaping (_ result:[String:AnyObject]?, _ isSuccess:Bool)->()) {
        
        let urlString:String
        let params = ["status": text]
        var name:String?
        var data:Data?
        
        if image == nil {   // 纯文字
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else{  // 带图片
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
    
        tokenRequest(method: .POST, URLString: urlString, parameters: params as [String:AnyObject]?, name: name, data: data, completion: {(json, isSuccess) in
            completion(json as? [String:AnyObject], isSuccess)
        })
    }
}


// MARK: - 请求用户信息
extension ScottNetwrokManager {
    func loadUserInfo(completion:@escaping (_ json:[String:AnyObject])->()) {
        guard let userId = self.userAccount.uid else {
            return
        }
        
        let urlStr = HttpRootURL + "2/users/show.json"
        let params = ["uid":userId]
        
        tokenRequest(URLString: urlStr, parameters: params as [String : AnyObject]?){(json, isSuccess) in
            completion(json as? [String : AnyObject] ?? [:])
        }
    }
}


// MARK: - OAuth认证
extension ScottNetwrokManager {
    func loadAccessToken(code:String, completion:@escaping (_ isSuccess:Bool)->()) {
        
        let urlStr = HttpRootURL + "oauth2/access_token"
        let params = ["client_id":ScottAppKey,
                      "client_secret":ScottAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":ScottRedirectURL]
        
        //发起网络请求
        request(method: .POST, URLString: urlStr, parameters: params as [String: AnyObject]?) { (json, isSuccess) in
            
            self.userAccount.yy_modelSet(with: json as? ([String:AnyObject]) ?? [:])
            
            self.loadUserInfo(completion: { (json) in
                self.userAccount.yy_modelSet(with: json)
                self.userAccount.saveAccount()
                completion(isSuccess)
            })
        }
    }
}
