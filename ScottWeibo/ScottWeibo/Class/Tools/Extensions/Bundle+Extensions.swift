//
//  Bundle+Extensions.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


extension Bundle {
    
    // 计算型属性(效率比方法快)
    var namespace:String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
