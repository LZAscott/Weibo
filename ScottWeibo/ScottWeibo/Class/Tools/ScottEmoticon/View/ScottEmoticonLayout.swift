//
//  ScottEmoticonLayout.swift
//  TestEmotica
//
//  Created by bopeng on 2017/1/23.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottEmoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
    
        scrollDirection = .horizontal
    }
}
