//
//  ScottComposeController.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/18.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit
import SVProgressHUD

class ScottComposeController: UIViewController {

    @IBOutlet weak var textView: ScottComposeTextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChage), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }

    @objc func keyboardFrameChage(noti:Notification){
    
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        toolBarBottomCons.constant = offset
        UIView.animate(withDuration: duration){
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: 发送微博
    @IBAction func sendBtnClick() {
        guard let text = textView.text else {
            return
        }
        
//        let img = UIImage(named: "icon_small_kangaroo_loading_1")
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        ScottNetwrokManager.shared.postStatus(text: text, image: nil){[weak self](result, isSuccess) in
            let noticeMessage = isSuccess ? "发送成功" : "发送失败"
            SVProgressHUD.showInfo(withStatus: noticeMessage)
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: { 
                    SVProgressHUD.setDefaultStyle(.light)
                    self?.dismissViewController()
                })
            }
        }
    }
    
    
    // MARK:切换表情键盘
    @objc fileprivate func emoticonKeyboard(){
        
        // 1.创建键盘视图
        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
        keyboardView.backgroundColor = UIColor.scott_random()
        
        // 2.设置键盘视图
        textView.inputView = (textView.inputView == nil) ? keyboardView : nil
        
        // 3.刷新键盘视图
        textView.reloadInputViews()
    }
    
    // MARK:点击关闭
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("发送微博界面消失")
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - UITextViewDelegate
extension ScottComposeController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}

// MARK: - 设置界面
fileprivate extension ScottComposeController {
    
    func setupUI() {
        setupNaviItem()
        setupToolBar()
    }
    
    func setupNaviItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", fontSize: 16, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendBtn)
        sendBtn.isEnabled = false
        
        // 用户名
        let name = ScottNetwrokManager.shared.userAccount.screen_name ?? ""
        let str:NSString = "发微博\n\(name)" as NSString
        let arr = str.components(separatedBy: "\n")
        let firstRange = str.range(of: arr[0])
        let secondRange = str.range(of: arr[1])
        
        let attrText = NSMutableAttributedString(string: str as String)
        
        attrText.addAttributes([NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont.systemFont(ofSize: 14)], range: firstRange)
        attrText.addAttributes([NSForegroundColorAttributeName:UIColor.lightGray, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: secondRange)
        
        titleLabel.attributedText = attrText
        
        navigationItem.titleView = titleLabel
    }
    
    func setupToolBar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        
        var itemArray = [UIBarButtonItem]()
        
        for item in itemSettings {
            guard let imgName = item["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imgName)
            let imageHightLight = UIImage(named: imgName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.setImage(imageHightLight, for: .highlighted)
            btn.sizeToFit()
            
            if let actionName = item["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            
            itemArray.append(UIBarButtonItem(customView: btn))
            
            // 添加弹簧
            itemArray.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        itemArray.removeLast()
        toolBar.items = itemArray
    }
}
