//
//  ScottRefreshControl.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/16.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

/// 观察者观察的key
private let ScottObserverKey = "contentOffset"


/// 刷新状态切换的零界点
///
/// - Normal: 普通状态(还未到达临界点)
/// - Pulling: 超过临界点，如果松手，开始刷新
/// - WillRefresh: 超过临界点，并且刷新
enum ScottRefreshStatus {
    case Normal
    case Pulling
    case WillRefresh
}

/// 刷新状态切换的临界点
fileprivate let ScottRefreshOffset:CGFloat = 122


class ScottRefreshControl: UIControl {

    // MARK: 属性
    private weak var scrollView:UIScrollView?
    
    fileprivate lazy var refreshView:ScottRefreshView = ScottRefreshView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    /*
        addSubview方法会调用
        当添加到父视图的时候，newSuperview是父视图
        当父视图被移除的时候，newSuperview是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 记录父视图
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        // KVO监听
        scrollView?.addObserver(self, forKeyPath: ScottObserverKey, options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        guard let sv = scrollView else {
            return
        }
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
    
        
        // 如果不是处于刷新状态，就更高高度
        if refreshView.refreshStatus != .WillRefresh {
            refreshView.parentHeight = height
        }
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if sv.isDragging {
            // 如果高度大于刷新临界点并且处于普通状态的时候
            if height > ScottRefreshOffset && refreshView.refreshStatus == .Normal {
                refreshView.refreshStatus = .Pulling
            }else if height <= ScottRefreshOffset && refreshView.refreshStatus == .Pulling {
                refreshView.refreshStatus = .Normal
            }
        }else{
            if refreshView.refreshStatus == .Pulling {
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: ScottObserverKey)
        super.removeFromSuperview()
    }
    
    /// 开始刷新
    func beginRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshStatus == .WillRefresh {
            return
        }
        
        refreshView.refreshStatus = .WillRefresh
        
        var insert = sv.contentInset
        insert.top += ScottRefreshOffset
        sv.contentInset = insert
        
        refreshView.parentHeight = ScottRefreshOffset
    }
    
    /// 结束刷新
    func endRefreshing() {
        
        guard let sv = scrollView else {
            return
        }
        
        if refreshView.refreshStatus != .WillRefresh {
            return
        }
        
        refreshView.refreshStatus = .Normal
        
        var insert = sv.contentInset
        insert.top -= ScottRefreshOffset
        sv.contentInset = insert
    }
}

extension ScottRefreshControl {
    fileprivate func setupUI(){
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}
