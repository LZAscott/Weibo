//
//  ScottWelcomView.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/13.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SDWebImage

class ScottWelcomView: UIView {
    
    
    @IBOutlet weak var avatarImv: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var avatarBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var avatarWidthCons: NSLayoutConstraint!
    
    class func welcomView() -> ScottWelcomView {
        let nib = UINib(nibName: "ScottWelcomView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottWelcomView
        v.frame  = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        
        guard let avatarUrl = ScottNetwrokManager.shared.userAccount.avatar_large,
            let url = URL(string: avatarUrl)
        else {
            return
        }
       
        avatarImv.layer.cornerRadius = avatarWidthCons.constant * 0.5
        avatarImv.layer.masksToBounds = true
        avatarImv.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layoutIfNeeded()
        
        avatarBottomCons.constant = bounds.size.height - 200
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.layoutIfNeeded()
        }, completion: {(_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipsLabel.alpha = 1.0
            }, completion: {(_) in
                self.removeFromSuperview()
            })
        })
    }
}
