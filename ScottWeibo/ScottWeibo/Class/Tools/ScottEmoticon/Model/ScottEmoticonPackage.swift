//
//  ScottEmoticonPackage.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottEmoticonPackage: NSObject {
    
    lazy var emoticons = [ScottEmoticon]()
    
    /// 表情包分组名
    var groupName:String?
    
    /// 背景图片名称
    var bgImageName:String?
    
    /// 表情包目录
    var directory:String? {
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "ScottEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String:String]],
                let models = NSArray.yy_modelArray(with: ScottEmoticon.self, json: array) as? [ScottEmoticon]
            else {
                return
            }
            
            // 遍历models
            for m in models {
                m.directory = directory
            }
            
            emoticons += models
        }
    }
    
    
    var numberOfPages:Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    
    /// 从懒加载的表情包中，按照page，截取最多20个表情模型的数组
    /// 例如有26个表情
    /// page=0, 返回 0-19 个模型
    /// page=1, 返回 20-25 个模型
    func emoticon(page:Int) -> [ScottEmoticon] {
        let count = 20
        let location = page * count
        var length = count
        
        // 判断数组是否越界
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        let range = NSRange(location: location, length: length)
        let subArray = (emoticons as NSArray).subarray(with: range)
        return subArray as! [ScottEmoticon]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
