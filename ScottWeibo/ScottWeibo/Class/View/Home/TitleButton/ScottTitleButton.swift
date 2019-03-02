//
//  ScottTitleButton.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/13.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottTitleButton: UIButton {

    init(title:String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        }else{
            setTitle(title!, for: .normal)
            setImage(UIImage(named:"navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named:"navigationbar_arrow_up"), for: .selected)
        }
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
        sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
            let imageV = imageView
        else {
            return
        }
        
        titleLabel.frame.origin.x = 0
        imageV.frame.origin.x = titleLabel.bounds.width + 2.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
