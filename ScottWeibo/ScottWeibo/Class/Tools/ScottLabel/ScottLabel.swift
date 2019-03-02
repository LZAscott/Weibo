//
//  ScottLabel.swift
//  ScottWeibo
//
//  Created by bopeng on 2017/1/22.
//  Copyright © 2017年 Scott. All rights reserved.
//

import UIKit

@objc
public protocol ScottLabelDelegate:NSObjectProtocol {
    
    /// 选中链接文本
    ///
    /// - Parameters:
    ///   - label: label
    ///   - text: 选中的文本
    @objc optional func labelDidSelectedLinkText(label:ScottLabel, text:String)
}

public class ScottLabel: UILabel {
    
    fileprivate let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    var linkTextColor = UIColor.blue
    var selectedBackgroundColor = UIColor.lightGray
    weak var delegate: ScottLabelDelegate?
    
    public override var text: String? {
        didSet {
            updateTextStorage()
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    public override var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    public override var textColor: UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareLabel()
    }
    
    public override func drawText(in rect: CGRect) {
        
        let range = glyphsRange()
        let offset = glyphsOffset(range: range)
        
        // 绘制背景(注意：绘制背景必须放在绘制字形前面)
        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        
        // 绘制字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    
    fileprivate lazy var linkRanges = [NSRange]()
    fileprivate var selectedRange:NSRange?
    // 属性文本存储
    fileprivate lazy var textStorage = NSTextStorage()
    // 负责文本字形布局
    fileprivate lazy var layoutManager = NSLayoutManager()
    // 设定文本绘制范围
    fileprivate lazy var textContainer = NSTextContainer()
}


// MARK: - touch events
extension ScottLabel {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1.获取用户点击的位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        selectedRange = linkRnageAt(location: location)
        modifySelectedAttribute(isSet: true)
    }
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1.获取用户点击的位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        if let range = linkRnageAt(location: location) {
            if !(range.location == selectedRange?.location && range.length == selectedRange?.length) {
                modifySelectedAttribute(isSet: false)
                selectedRange = range
                modifySelectedAttribute(isSet: true)
            }
        } else {
            modifySelectedAttribute(isSet: false)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedRange = selectedRange else {
            return
        }
        
        let text = (textStorage.string as NSString).substring(with: selectedRange)
        delegate?.labelDidSelectedLinkText?(label: self, text: text)
        
        let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: when){
            self.modifySelectedAttribute(isSet: false)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(isSet: false)
    }
    
    fileprivate func modifySelectedAttribute(isSet:Bool) {
        if selectedRange == nil {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSForegroundColorAttributeName] = linkTextColor
        
        guard let range = selectedRange else {
            return
        }
        
        if isSet {
            attributes[NSBackgroundColorAttributeName] = selectedBackgroundColor
        } else {
            attributes[NSBackgroundColorAttributeName] = UIColor.clear
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range)
        
        setNeedsDisplay()
    }
    
    fileprivate func linkRnageAt(location:CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        let offset = glyphsOffset(range: glyphsRange())
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for r in linkRanges {
            if NSLocationInRange(index, r) {
                return r
            }
        }
        
        return nil
    }
}


fileprivate extension ScottLabel {

    /// 准备文本系统
    func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        isUserInteractionEnabled = true
    }
    
    func updateTextStorage(){
        guard let attributedText = attributedText else {
            return
        }
        
        let attrStringM = addLineBreak(attrString: attributedText)
        regexLinkRanges(attrString: attrStringM)
        addLinkAttribute(attrStringM: attrStringM)
        
        textStorage.setAttributedString(attrStringM)
        setNeedsDisplay()
    }
    
    /// add line break mode
    func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            // iOS 8.0 can not get the paragraphStyle directly
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        
        return attrStringM
    }

    
    func addLinkAttribute(attrStringM: NSMutableAttributedString){
        if attrStringM.length == 0 {
            return
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        attributes[NSFontAttributeName] = font!
        attributes[NSForegroundColorAttributeName] = textColor
        attrStringM.addAttributes(attributes, range: range)
        attributes[NSForegroundColorAttributeName] = linkTextColor
        
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
    
    func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    func glyphsOffset(range:NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint(x: 0, y: height)
    }
}


// MARK: - 正则表达式函数
fileprivate extension ScottLabel {
    func regexLinkRanges(attrString:NSAttributedString) {
        linkRanges.removeAll()
        
        let regexRange = NSRange(location: 0, length: attrString.string.characters.count)
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else {
                break
            }
            
            let results = regex.matches(in: attrString.string, options: [], range: regexRange)
            for r in results {
                linkRanges.append(r.rangeAt(0))
            }
        }
    }
}
