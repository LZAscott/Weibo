//
//  ScottTestController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

class ScottTestController: ScottBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc fileprivate func showNextAction(){
        let vc = ScottTestController()
        navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ScottTestController {
    override func setupTableView() {
        super.setupTableView()
        
        scottNaviItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(showNextAction))
    }
}
