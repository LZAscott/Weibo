//
//  ScottCTRefreshView.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/17.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottCTRefreshView: ScottRefreshView {
    
    
    override var parentHeight: CGFloat {
        didSet {
            if parentHeight < 25 {
                return
            }
            
            var scale:CGFloat
            
            if parentHeight > 122 {
                scale = 1
            }else{
                scale = 1-((122 - parentHeight)/(122-25))
            }
            
            kangarolImv.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    

    /// 建筑物
    @IBOutlet weak var buildingImv: UIImageView!
    /// 袋鼠
    @IBOutlet weak var kangarolImv: UIImageView!
    /// 地球
    @IBOutlet weak var earthImv: UIImageView!
    
    
    override func awakeFromNib() {
        //1.房子
        let bImg1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImg2 = #imageLiteral(resourceName: "icon_building_loading_2")
    
        
        buildingImv.image = UIImage.animatedImage(with: [bImg1,bImg2], duration: 0.5)
        
        //2.地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthImv.layer.add(anim, forKey: nil)
        
        //袋鼠
        let KImg1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let Kimg2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        kangarolImv.image = UIImage.animatedImage(with: [KImg1,Kimg2], duration: 0.4)
        
        kangarolImv.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        //设置锚点
        kangarolImv.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //设置center
        kangarolImv.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height - 25)
    }
}
