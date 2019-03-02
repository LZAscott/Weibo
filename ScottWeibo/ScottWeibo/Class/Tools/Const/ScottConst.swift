//
//  ScottConst.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/12.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation

/// AppKey
let ScottAppKey = "1375089591"

/// AppSecret
let ScottAppSecret = "e8ff5fdb49e359d43d229ab724c48b36"

/// RedirectURL
let ScottRedirectURL = "http://www.baidu.com"

/// 应该登录的通知
let ScottShouldLoginNotifacation = "ScottShouldLoginNotifacation"

/// 登录成功的通知
let ScottLoginSuccessNotifacation = "ScottLoginSuccessNotifacation"


/// 微博配图外部间距
let ScottStatusPicViewOuterMargin = CGFloat(12)
/// 微博配图内部间距
let ScottStatusPicViewInnerMargin = CGFloat(3)
/// 微博配图视图宽度
let ScottStatusPicViewWidth = UIScreen.scott_screenWidth() - 2 * ScottStatusPicViewOuterMargin
/// 微博配图图片宽度
let ScottStatusItemWidth = (ScottStatusPicViewWidth - 2 * ScottStatusPicViewInnerMargin) / 3
