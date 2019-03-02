//
//  ScottEmoticonInputView.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/23.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

private let cellID = "cellID"

class ScottEmoticonInputView: UIView {
    
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    class func inputView() -> ScottEmoticonInputView {
        let nib = UINib(nibName: "ScottEmoticonInputView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ScottEmoticonInputView
        return v
    }
    
    override func awakeFromNib() {
        collectionView.register(ScottEmoticonCell.self, forCellWithReuseIdentifier: cellID)
    }
}


extension ScottEmoticonInputView:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ScottEmoticonManager.shared.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScottEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScottEmoticonCell
        
        // 2.设置cell
        let emoticons = ScottEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        
        cell.emoticons = emoticons
        
        // 3.返回cell
        return cell
    }
}
