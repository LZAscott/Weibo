//
//  String+Extensions.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/19.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation


extension String {

    func scott_href() -> ((link: String, text: String))? {
        //匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        // 创建正则表达式
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result =  regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))else {
                return nil
        }
        //获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link,text)
    }
    
    
    /// 汉字转拼音
    ///
    /// - Returns: 拼音
    func toPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        //去掉空格
        return string.replacingOccurrences(of: " ", with: "")
    }
}
