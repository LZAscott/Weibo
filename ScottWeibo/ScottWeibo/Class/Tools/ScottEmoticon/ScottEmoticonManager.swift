//
//  ScottEmoticonManager.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


class ScottEmoticonManager {
    
    lazy var packages = [ScottEmoticonPackage]()
    
    lazy var bundle:Bundle = {
        let path = Bundle.main.path(forResource: "ScottEmoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()
    
    /// 表情管理器的单例
    static let shared:ScottEmoticonManager = {
        let shareInstance = ScottEmoticonManager()
        return shareInstance
    }()
    
    private init(){
        loadPackages()
    }
}




// MARK: - 表情符号处理
extension ScottEmoticonManager {
    
    /// 根据string在所有的表情符号中查找对应的表情模型对象
    ///
    /// - Parameter string: 表情string
    /// - Returns: 如果找到，返回表情模型，否则返回nil
    func findEmoticon(string:String) -> ScottEmoticon? {
        // 1.遍历表情包
        for p in packages {
            // 2.在表情数组中过滤string
            
            // 写法一:
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            // 写法二:
//            let result = p.emoticons.filter(){ (em) -> Bool in
//                return em.chs == string
//            }
            
            // 写法三:
//            let result = p.emoticons.filter(){
//                return $0.chs == string
//            }
            
            // 写法四:
            let result = p.emoticons.filter(){ $0.chs == string }
            
            // 结果数组的数量
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
    
    
    /// 表情符号字符串的处理
    ///
    /// - Parameter string: 表情符号
    /// - Returns: 富文本
    func emoticon(string:String, font:UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        let matchs = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        for m in matchs.reversed() {
            let r = m.rangeAt(0)
            let resultStr = (attrString.string as NSString).substring(with: r)
            
            if let emoticon = ScottEmoticonManager.shared.findEmoticon(string: resultStr) {
                attrString.replaceCharacters(in: r, with: emoticon.attributedText(font: font))
            }
        }
        
        // 统一设置一遍字符串的属性
        attrString.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.darkGray], range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }
}



// MARK: - 加载表情包数据处理
fileprivate extension ScottEmoticonManager {
    
    func loadPackages() {
        // 1.读取emoticons.plist
        guard let path = Bundle.main.path(forResource: "ScottEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let models = NSArray.yy_modelArray(with: ScottEmoticonPackage.self, json: array) as? [ScottEmoticonPackage]
        else {
            return
        }
        
        // 使用 += 不需要再分配空间，直接加载数据 比用 = 更合适
        packages += models
    }
}
