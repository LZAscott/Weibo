//
//  ScottHomeController.swift
//  ScottWeibo
//
//  Created by Scott_Mr on 2017/1/11.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD

private let ScottOriginStatusCellID = "ScottOriginStatusCellID"
private let ScottRetweetStatusCellID = "ScottRetweetStatusCellID"

class ScottHomeController: ScottBaseController {
    
    fileprivate lazy var listViewModel = ScottStatusListViewModel()
    
    fileprivate lazy var messageCountView:UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 20, width: UIScreen.scott_screenWidth(), height: 44)
        v.backgroundColor = UIColor(red: 253.0/255, green: 143.0/255, blue: 25.0/255, alpha: 0.5)
        return v
    }()
    
    fileprivate lazy var messageCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "刷新到0条数据"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.insertSubview(messageCountView, belowSubview: scottNaviBar)
        messageCountView.addSubview(messageCountLabel)
        messageCountLabel.frame = messageCountView.bounds
    }
    
    
    // MARK: 加载数据
    override func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3){ [weak self] in
            self?.listViewModel.loadStatusList(isPullup: self!.isPullup){(isSuccess, shouldRefresh, count) in
                
                self?.refreshCtrl?.endRefreshing()
                
                if self!.isPullup == false { // 刷新
                    self?.navigationController?.tabBarItem.badgeValue = nil
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    
                    if count > 0 {
                        self?.messageCountLabel.text = "刷新到\(count)条微博"
                        UIView.animate(withDuration: 2, animations: {
                            self?.messageCountView.transform = CGAffineTransform(translationX: 0, y: 44)
                        }, completion: {_ in
                            UIView.animate(withDuration: 0.5, animations: { 
                                self?.messageCountView.transform = CGAffineTransform.identity
                            })
                        })
                    }
                }
                
                self?.isPullup = false
                
                
                if shouldRefresh {
                    self?.tableView?.reloadData()
                }
            }
        }
    }

    
    @objc fileprivate func showFriend(){
        let vc = ScottTestController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ScottHomeController {
    
    // MARK: 重写父类方法
    override func setupTableView() {
        super.setupTableView()
        
        scottNaviItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize: 16, target: self, action: #selector(showFriend))
        
        tableView?.register(UINib(nibName: "ScottOriginStatusCell", bundle: nil), forCellReuseIdentifier: ScottOriginStatusCellID)
        tableView?.register(UINib(nibName: "ScottRetweetStatusCell", bundle: nil), forCellReuseIdentifier: ScottRetweetStatusCellID)
        
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = .none
        setupTitleView()
    }
    
    
    private func setupTitleView(){
        let btn = ScottTitleButton(title: ScottNetwrokManager.shared.userAccount.screen_name)
        btn.addTarget(self, action: #selector(titleBtnClick(btn:)), for: .touchUpInside)
        scottNaviItem.titleView = btn
    }
    
    @objc fileprivate func titleBtnClick(btn:ScottTitleButton){
        if btn.currentTitle == nil {
            return
        }
        btn.isSelected = !btn.isSelected
        
        // FIXME: 待完善
    }
}


// MARK: - 数据源代码
extension ScottHomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellID = viewModel.status.retweeted_status != nil ? ScottRetweetStatusCellID : ScottOriginStatusCellID
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ScottStatusCell
        cell.delegate = self
        
        cell.viewModel = viewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
}

extension ScottHomeController:ScottStatusCellDelegate {
    func scottStatusCellDidSelectedURLString(cell: ScottStatusCell, urlString: String) {
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            let vc = ScottWebViewController()
            vc.urlString = urlString
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if urlString.hasPrefix("#") {
            print("话题")
        }
        
        if urlString.hasPrefix("@") {
            print("@")
        }
    }
}
