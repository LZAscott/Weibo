//
//  ScottEmoticonCell.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/23.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit


/// 表情的页面cell，每一个页面显示20个表情
/// 每一个cell中用9宫格算法 自己添加20个表情
/// 最后一个位置放 删除 按钮
class ScottEmoticonCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var emoticons:[ScottEmoticon]? {
        didSet {
            
//            for emoticon in emoticons {
//                
//            }
            print(emoticons?.count ?? "0")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


extension ScottEmoticonCell {
    func setupUI() {
        let rowCount:Int = 3
        let colCount:Int = 7
        
        let leftMargin:CGFloat = 8
        let bottomMargin:CGFloat = 16
        
        let width:CGFloat = (bounds.width - leftMargin * 2) / CGFloat(colCount)
        let height:CGFloat = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        // 1.连续创建21个按钮
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let btn = UIButton()
            btn.backgroundColor = UIColor.red
            let x = leftMargin + CGFloat(col) * width
            let y = CGFloat(row) * height
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            contentView.addSubview(btn)
        }
    }
}
