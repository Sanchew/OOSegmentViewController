//
//  OOSegmentNavigationBar.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

open class OOSegmentNavigationBar : UIScrollView {

    var titles = [String]() {
        didSet {
            configItems()
        }
    }
    
    var titleColor : UIColor!
    var titleSelectedColor : UIColor!
    var fontSize : CGFloat!
    var cursorBottomMargin : CGFloat?
    var cursorHeight : CGFloat!
    open var itemMargin : CGFloat = 0
    open var itemOffset : CGFloat = 0
    
    var segmentViewController : OOSegmentViewController?
    
    fileprivate var titleItemMap = [String:UIButton]()
    fileprivate var selectedItem : UIButton!
    
    var moveEffect : CursorMoveEffect!
    fileprivate var contentView = UIView(frame: CGRect.zero)
//    private var lastContentOffset = CGFloat(0)
    fileprivate var cursor = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 2))
    var cursorColor : UIColor! {
        didSet {
            cursor.backgroundColor = cursorColor
        }
    }
    
    init(){
        super.init(frame: CGRect.zero)
        configUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if contentView.frame == CGRect.zero {
            contentView.frame.size.height = self.frame.size.height
            let height = self.frame.height
            if let margin = cursorBottomMargin {
                cursor.frame = CGRect(x: 0, y: height - cursorHeight - margin, width: 0, height: cursorHeight)
            } else {
                cursor.frame = CGRect(x: 0, y: height - cursorHeight - (height-fontSize)/4, width: 0, height: cursorHeight)
            }
            layoutItems()
        }
        
    }
    
    func configUI() {
        self.showsHorizontalScrollIndicator = false
        
        addSubview(contentView)
        cursor.backgroundColor = cursorColor
        contentView.addSubview(cursor)
    }

    func configItems() {
//        guard titleItemMap.count == 0 else {
//            return
//        }
        guard let _ = titleColor,let _ = titleSelectedColor,let _ = fontSize else {
            return
        }
        print("configItems")
        titleItemMap.values.forEach { $0.removeFromSuperview() }
        titles.enumerated().forEach {
            let item = UIButton()
            item.tag = $0
            item.setTitle($1, for: UIControlState())
            item.setTitleColor(titleColor, for: UIControlState())
            item.setTitleColor(titleSelectedColor, for: .selected)
            item.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            item.addTarget(self, action: #selector(itemClick(_:)), for: .touchUpInside)
            titleItemMap[$1] = item
            contentView.addSubview(item)
            
        }
        layoutItems()
    }
    
    func layoutItems() {
        guard frame.height > 0 else {
            return
        }
        contentView.frame.origin.x  = 0
        var contentWidth = itemOffset
        titles.enumerated().forEach {
            let item = titleItemMap[$1]
            let itemWidth = ceil(titleWidthAtFont(UIFont.systemFont(ofSize: fontSize), index: $0))
            item?.frame = CGRect(x: contentWidth, y: 0, width: itemWidth, height: self.frame.height)
            if $0 == segmentViewController?.pageIndex ?? 0 {
                cursor.frame.size.width = itemWidth + 4
                cursor.frame.origin.x = contentWidth - 2
                item?.isSelected = true
                selectedItem = item
            }
            contentWidth += itemWidth + itemMargin
        }
        contentWidth += itemOffset - itemMargin
        
        contentSize.width = contentWidth
        contentView.frame.size.width = contentWidth
//        contentView.frame.origin.x = contentWidth < CGRectGetWidth(self.frame) ? (CGRectGetWidth(self.frame) - contentWidth) / 2.0 : 0
        if contentWidth < self.frame.width {
            contentView.frame.origin.x = (self.frame.width - contentWidth) / 2.0
        }
    }
    
    func itemClick(_ sender:UIButton) {
        segmentViewController?.moveToControllerAtIndex(sender.tag)
    }
    
    func titleWidthAtFont(_ font:UIFont,index:Int) -> CGFloat {
        return titles[index].boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size.width + 4
    }
    
    func updateSelectItem(_ newIndex: Int) {
//        if let pageIndex = segmentViewController?.pendingIndex {
            selectedItem.isSelected = false
            selectedItem = titleItemMap[titles[newIndex]]
            selectedItem.isSelected = true
//        }
    }
    
}


extension OOSegmentNavigationBar : UIScrollViewDelegate {
    
    
    // XXX: 这还是有点小问题  当用户从最右开始拖动 cursor 会有跳动
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        guard let segmentViewController = segmentViewController else {
            return
        }
        let fullWidth = segmentViewController.view.frame.width
        // view移动完后系统会重新设置当前view的位置
        if scrollView.contentOffset.x == fullWidth {
            return
        }
        
        guard scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= fullWidth * 2 else {
            return
        }
        
        let oldIndex = segmentViewController.pageIndex
        var index = segmentViewController.pendingIndex
        
        if abs(index - oldIndex) < 2 {
            index = scrollView.contentOffset.x > fullWidth ? oldIndex + 1 : oldIndex - 1
        }
        
        guard index >= 0 && index < titles.count else {
            return
        }
        let button = titleItemMap[titles[index]]! , oldButton = titleItemMap[titles[oldIndex]]!
       
        if let _ = moveEffect.scroll?(scrollView, navBar: self, cursor: self.cursor, newItem: button, oldItem: oldButton) {
            return
            
        }
        
        let xScale = scrollView.contentOffset.x.truncatingRemainder(dividingBy: fullWidth) / fullWidth
        
        let indicatorWidth = button.frame.size.width // titleWidthAtFont(titleFont, index: index)
        let oldWidth = oldButton.frame.size.width // titleWidthAtFont(titleFont, index: oldIndex)
        let f = CGFloat(button.tag - oldButton.tag)
        var s = (f > 0 ? 1.0 - (xScale == 0 ? 1.0 : xScale) : xScale) // == 1.0 ? xScale : 0
        s = s < 0.01 || s > 0.99 ? round(s) : s
        let w = round((oldWidth - indicatorWidth) * s + indicatorWidth)
        let x = round((oldButton.frame.origin.x - button.frame.origin.x) * s) + button.frame.origin.x
        let cx = round((oldButton.center.x - button.center.x) * s) + button.center.x
        
        if let _ = moveEffect.scroll?(scrollView, navBar: self, cursor: self.cursor, fullWidth: fullWidth, xScale: xScale, correctXScale: s,computeWidth:w, leftXOffset: x, centerXOffset: cx, finished: s==0) {
            return
        }
    }
    
}
