//
//  OOSegmentNavigationBar.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

public class OOSegmentNavigationBar : UIScrollView {

    var titles = [String]() {
        didSet {
            configItems()
        }
    }
    
    var titleColor : UIColor!
    var titleSelectedColor : UIColor!
    var fontSize : CGFloat!
    public var itemMargin : CGFloat = 0
    public var itemOffset : CGFloat = 0
    
    var segmentViewController : OOSegmentViewController?
    
    private var titleItemMap = [String:UIButton]()
    private var selectedItem : UIButton!
    
    var moveEffect : CursorMoveEffect!
    private var contentView = UIView(frame: CGRectZero)
//    private var lastContentOffset = CGFloat(0)
    private var cursor = UIView(frame: CGRectMake(0,0,0,2))
    var cursorColor : UIColor! {
        didSet {
            cursor.backgroundColor = cursorColor
        }
    }
    
    init(){
        super.init(frame: CGRectZero)
        configUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if contentView.frame == CGRectZero {
            contentView.frame.size.height = self.frame.size.height
            let height = CGRectGetHeight(self.frame)
            cursor.frame = CGRectMake(0, height - 2 - (height-fontSize)/4, 0, 2)
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
        guard titleItemMap.count == 0 else {
            return
        }
        titles.enumerate().forEach {
            let item = UIButton()
            item.tag = $0
            item.setTitle($1, forState: .Normal)
            item.setTitleColor(titleColor, forState: .Normal)
            item.setTitleColor(titleSelectedColor, forState: .Selected)
            item.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
            item.addTarget(self, action: #selector(itemClick(_:)), forControlEvents: .TouchUpInside)
            titleItemMap[$1] = item
            contentView.addSubview(item)
            
        }
//        layoutItems()
    }
    
    func layoutItems() {
        var contentWidth = itemMargin + itemOffset
        titles.enumerate().forEach {
            let item = titleItemMap[$1]
            let itemWidth = ceil(titleWidthAtFont(UIFont.systemFontOfSize(fontSize), index: $0))
            item?.frame = CGRectMake(contentWidth, 0, itemWidth, CGRectGetHeight(self.frame))
            if $0 == segmentViewController?.pageIndex ?? 0 {
                cursor.frame.size.width = itemWidth + 4
                cursor.frame.origin.x = contentWidth - 2
                item?.selected = true
                selectedItem = item
            }
            contentWidth += itemWidth + itemMargin
        }
        contentWidth += itemOffset
        contentSize.width = contentWidth
        contentView.frame.size.width = contentWidth
//        contentView.frame.origin.x = contentWidth < CGRectGetWidth(self.frame) ? (CGRectGetWidth(self.frame) - contentWidth) / 2.0 : 0
        if contentWidth < CGRectGetWidth(self.frame) {
            contentView.frame.origin.x = (CGRectGetWidth(self.frame) - contentWidth) / 2.0
        }
    }
    
    func itemClick(sender:UIButton) {
        segmentViewController?.moveToControllerAtIndex(sender.tag)
    }
    
    func titleWidthAtFont(font:UIFont,index:Int) -> CGFloat {
        return titles[index].boundingRectWithSize(CGSize(width: CGFloat.max, height: font.lineHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size.width + 4
    }
    
    func updateSelectItem(newIndex: Int) {
//        if let pageIndex = segmentViewController?.pendingIndex {
            selectedItem.selected = false
            selectedItem = titleItemMap[titles[newIndex]]
            selectedItem.selected = true
//        }
    }
    
}


extension OOSegmentNavigationBar : UIScrollViewDelegate {
    
    
    // XXX: 这还是有点小问题  当用户从最右开始拖动 cursor 会有跳动
    public func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        guard let segmentViewController = segmentViewController else {
            return
        }
        let fullWidth = CGRectGetWidth(segmentViewController.view.frame)
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
        
        let xScale = scrollView.contentOffset.x % fullWidth / fullWidth
        
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
