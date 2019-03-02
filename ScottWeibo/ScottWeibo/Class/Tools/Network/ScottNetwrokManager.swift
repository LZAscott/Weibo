//
//  ScottNetwrokManager.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import AFNetworking

enum ScottHttpMethod {
    case GET
    case POST
}

class ScottNetwrokManager: AFHTTPSessionManager {
    static let shared:ScottNetwrokManager = {
        let shareInstance = ScottNetwrokManager()
        shareInstance.requestSerializer.timeoutInterval = 10
        shareInstance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return shareInstance
    }()

    lazy var userAccount = ScottUserAccount()
    
    var userLogin:Bool {
        return userAccount.access_token != nil
    }
    
    /// 负责带token的请求
    ///
    /// - Parameters:
    ///   - method: 请求方式
    ///   - URLString: 接口
    ///   - parameters: 参数
    ///   - name: 上传文件使用的字段名，默认为nil，就不是上传文件
    ///   - data: 上传文件的二进制数据，默认为nil，不上传文件
    ///   - completion: 回调
    func tokenRequest(method:ScottHttpMethod = .GET, URLString:String, parameters:[String:AnyObject]?,name:String? = nil, data:Data? = nil, completion:@escaping (_ json:AnyObject?, _ isSuccess:Bool)->()) {
        
        // 判断token是否为nil
        guard let token = userAccount.access_token else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: nil)
            completion(nil, false)
            return
        }
        
        var parameters = parameters
        if parameters == nil {
            parameters = [String:AnyObject]()
        }
        
        parameters!["access_token"] = token as AnyObject?
        
        if let name = name,
            let data = data {
            upLoad(URLString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        }else{
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
    }
    
    
    
    /// 上传文件必须是POST方法，GET只能获取数据
    /// 封装AFNetworking 上传文件
    ///
    /// - Parameters:
    ///   - URLString: 接口
    ///   - parameters: 参数
    ///   - name: 接收上传数据的服务器字段（name - 要咨询公司的后台）"pic"
    ///   - data: 要上传的二进制数据
    ///   - completion: 完成的回调
    func upLoad(URLString:String, parameters:[String:AnyObject]?, name:String, data:Data, completion:@escaping (_ json:AnyObject?, _ isSuccess:Bool)->()) {
        post(URLString, parameters: parameters, constructingBodyWith: {(formData) in
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
        }, progress: nil, success:{(_, json) in
            completion(json as AnyObject?, true)
        }, failure: {(task, error) in
            
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 { // token过期
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: "token过期")
            }
            
            completion(nil, false)
        })
    }
    
    
    /// 封装AFNetworking GET/POST网络请求
    ///
    /// - Parameters:
    ///   - method: 请求方法
    ///   - URLString: 接口
    ///   - parameters: 参数
    ///   - completion: 回调
    func request(method:ScottHttpMethod = .GET, URLString:String, parameters:[String:AnyObject]?, completion:@escaping (_ json:AnyObject?, _ isSuccess:Bool)->()) {
        
        // 成功回调
        let success = {(task:URLSessionDataTask, json:Any?)->() in
            completion(json as AnyObject?, true)
        }
        
        // 失败回调
        let failure = {(task:URLSessionDataTask?, error:Error) in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 { // token过期
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ScottShouldLoginNotifacation), object: "token过期")
            }
            
            completion(nil, false)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
