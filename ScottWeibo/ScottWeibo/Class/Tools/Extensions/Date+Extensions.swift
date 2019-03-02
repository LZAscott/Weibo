//
//  Date+Extensions.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/19.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation


extension Date {
    
    func scottDateDescription() -> String {
        // 1. 获取当前日历
        let calendar = NSCalendar.current
        
        // 2. 判断是否是今天
        if calendar.isDateInToday(self) {
            var interval:NSInteger = abs(NSInteger(self.timeIntervalSinceNow))
            
            if interval < 60 {
                return "刚刚"
            }
            
            interval /= 60
            if interval < 60 {
                return String(format: "%zd 分钟前", interval)
            }
            
            return String(format: "%zd 小时前", interval / 60)
        }
        
        // 3.昨天
        let formatString:NSMutableString = NSMutableString(string: " HH:mm")
        if calendar.isDateInYesterday(self) {
            formatString.insert("昨天", at: 0)
        }else{
            formatString.insert("MM-dd", at: 0)
            
            // 4.是否是当年
            let components = calendar.dateComponents([Calendar.Component.year], from: self, to: Date())
            
            if components.year != 0 {
                formatString.insert("yyyy-", at: 0)
            }
        }
        
        // 5. 转换格式字符串
        let fmt = DateFormatter()
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        fmt.dateFormat = formatString as String!
        return fmt.string(from: self)
    }
}
