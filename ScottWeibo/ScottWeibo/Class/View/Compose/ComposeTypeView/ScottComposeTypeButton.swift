//
//  ScottComposeTypeButton.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/17.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottComposeTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var clsName:String?
    
    class func compeTypeButton(imageName:String, title:String) -> ScottComposeTypeButton {
        let nib = UINib(nibName: "ScottComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottComposeTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
}
