//
//  ScottStatusViewModel.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/15.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation


/// 单条微博的视图模型
class ScottStatusViewModel:CustomStringConvertible {
    
    /// 微博模型
    var status:ScottStatus
    /// 会员图标
    var memberIcon:UIImage?
    /// 认证图标 0：认证用户， 2，3，5：企业认证， 220：达人
    var vipIcon:UIImage?
    /// 转发数
    var retweetedStr:String?
    /// 评论数
    var commentStr:String?
    /// 点赞数
    var likeStr:String?
    
    var picViewSize:CGSize = CGSize()
    
    /// 创建时间
    var createTime:String?
    
    /// 如果是被转发的微博, 则原创微博一定没有配图
    var picURLs:[ScottStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 微博正文的属性文本
    var statusAttrText:NSAttributedString?
    /// 被转发微博的属性文本
    var retweetedAttrText:NSAttributedString?
    
    /// 行高
    var rowHeight:CGFloat = 0
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    ///
    /// - returns: 返回单条微博视图模型
    init(model:ScottStatus) {
        self.status = model
        
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imgName = "common_icon_membership_level\(status.user?.mbrank ?? 1)"
            self.memberIcon = UIImage(named: imgName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        createTime = caculateStatusTime(time: model.created_at)
        
        retweetedStr = countStr(count: model.reposts_count, defaultStr: "转发")
        commentStr = countStr(count: model.comments_count, defaultStr: "评论")
        likeStr = countStr(count: model.attitudes_count, defaultStr: "赞")
        
        // 计算配图大小(有原创的就计算原创的，有转发的，就计算转发的)
        picViewSize = caculatePicView(count: picURLs?.count)
        
        
        let originFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        /// 原微博文字
        statusAttrText = ScottEmoticonManager.shared.emoticon(string:model.text ?? "", font:originFont)
        
        /// 设置被转发微博文字
        let rText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
        retweetedAttrText = ScottEmoticonManager.shared.emoticon(string:rText, font:retweetedFont)
        
        updateRowHeight()
    }
    
    /// 处理微博创建时间
    private func caculateStatusTime(time:String?) -> String {
        guard let time = time else {
            return ""
        }
        let fmt = DateFormatter()
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        fmt.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        // 将字符串转为date
        guard let resultDate = fmt.date(from: time) else {
            return ""
        }
        
        return resultDate.scottDateDescription()
    }
    
    
    /// 根据当前视图模型计算行高
    private func updateRowHeight() {
        // 原创微博
        /*
         顶部分割视图(12)+间距(12)+头像高度(34)+间距(12)+正文高度(需要计算)+配图视图高度(需要计算)+间距(12)+底部视图高度(35)
         正文字体大小：15
         */
        
        // 转发微博
        /*
         顶部分割视图(12)+间距(12)+头像高度(34)+间距(12)+正文高度(需要计算)+间距(12)+间距(12)+转发文本高度(需要计算)+配图视图高度(需要计算)+间距(12)+底部视图高度(35)
         正文字体大小：15
         转发文本字体大小：14
         */
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolBarHeight:CGFloat = 35

        
        var height:CGFloat = 0
        
        height = 2 * margin + iconHeight + margin
        let size = CGSize(width: (UIScreen.scott_screenWidth() - 2 * margin), height: CGFloat(MAXFLOAT))
        
        if let text = statusAttrText {
            height += text.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).height
        }
        
        if status.retweeted_status != nil {
            height += 2 * margin
            
            // 转发文本高度
            if let text = retweetedAttrText {
                height += text.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        
        height += picViewSize.height + margin + toolBarHeight
        
        rowHeight = height
    }
    
    
    /// 使用单个图像，更新视图配图大小
    ///
    /// - Parameter image: 缓存的单张图像
    func updateSigleImageSize(image:UIImage){
        var size = image.size
        
        // 过宽图像处理
        let maxWidth:CGFloat = 300
        if size.width > maxWidth {
            // 等比例调整高度
            size.width = maxWidth
            size.height = size.width * (image.size.height / image.size.width)
        }
        
        // 过窄图像处理
        let minWidth:CGFloat = 40
        if size.width < minWidth {
            size.width = minWidth
            
            // 特殊处理高度,否则高度太大，影响用户体验
            size.height = size.width * (image.size.height / image.size.width) / 4
        }
        
        // 过长图片处理
        let maxHeight:CGFloat = 300
        if size.height > maxHeight {
            size.height = maxHeight * 0.5
        }
        
        size.height += ScottStatusPicViewOuterMargin
        picViewSize = size
        
        updateRowHeight()
    }
    
    /// 计算图片配图大小
    private func caculatePicView(count:Int?) -> CGSize {

        // 计算高度
        if count == nil || count == 0 {
            return CGSize()
        }
        
        // 行数
        let row = (count! - 1) / 3 + 1
        // 根据行数算高度
        let height = ScottStatusPicViewOuterMargin + CGFloat(row) * ScottStatusItemWidth + CGFloat((row - 1)) * ScottStatusPicViewInnerMargin
        
        return CGSize(width: ScottStatusPicViewWidth, height: height)
    }
    
    
    /// 给定一个数字返回对应描述结果
    private func countStr(count:Int, defaultStr:String) -> String {
        if count == 0 {
            return defaultStr
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    var description: String {
        return status.description
    }
}
