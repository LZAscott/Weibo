//
//  ScottStatusListViewModel.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/13.
//  Copyright © 2017年 Scott. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage

/// 上拉刷新最大尝试次数
private let maxPullupErrorTimes = 3

class ScottStatusListViewModel {
    
    
    /// 微博视图模型数组
    lazy var statusList = [ScottStatusViewModel]()
    
    /// 记录上拉刷新错误次数
    fileprivate var pullupErrorTimes = 0
    
    /// 加载微博列表
    ///
    /// - Parameters:
    ///   - isPullup: 是否上拉加载标记
    ///   - completion: 完成回调
    func loadStatusList(isPullup:Bool = false, completion:@escaping (_ isSuccess:Bool, _ shouldRefresh:Bool, _ count:Int)->()){
        
        if isPullup && pullupErrorTimes > maxPullupErrorTimes {
            completion(true, false, 0)
            return
        }
        
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !isPullup ? 0 : (statusList.last?.status.id ?? 0)
        
        ScottNetwrokManager.shared.statusList(since_id: since_id, max_id: max_id){(list, isSuccess) in
            
            // 0. 判断网络请求是否成功
            if !isSuccess {
                completion(false, false, 0)
                return
            }
            
            // 1.定义结果可变数组
            var array = [ScottStatusViewModel]()
            for dict in list ?? [] {
                
                // 1.1创建微博模型
                guard let model = ScottStatus.yy_model(with: dict) else {
                    continue
                }
                
                array.append(ScottStatusViewModel(model: model))
            }
            
            // 拼接数据
            if isPullup { // 上拉
                self.statusList += array
            }else{  // 下拉
                self.statusList = array + self.statusList
            }
            
            if isPullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false, array.count)
            }else{
                self.cacheSigleImage(list: array, completion:completion)
            }
        }
    }
    
    
    
    // MARK: 缓存本次下载微博数据数组中的单张图像
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - Parameter list: 本次下载的视图模型数组
    private func cacheSigleImage(list:[ScottStatusViewModel], completion:@escaping (_ isSuccess:Bool, _ shouldRefresh:Bool, _ count:Int)->()){
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        
        // 遍历数组，查找微博数组中有单张图像的，进行缓存
        for vm in list {
            // 1.判断图片数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            // 获取图像类型（代码执行到此，数组中有且仅有一张图片）
            guard let pic = vm.picURLs![0].thumbnail_pic,
                let url = URL(string: pic)
            else {
                continue
            }
            
            // 入组
            group.enter()
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    length += data.count
                    vm.updateSigleImageSize(image: image)
                }
                
                // 出组
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("图像缓存\(length/1024)k")
            
            //完成回调
            completion(true, true, list.count)
            
        }
    }
}
