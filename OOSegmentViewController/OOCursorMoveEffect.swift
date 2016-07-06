//
//  OOCursorMoveEffect.swift
//  OOSegmentViewController
//
//  Created by lee on 16/7/6.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

@objc public protocol CursorMoveEffect {
    optional func scroll(scrollView:UIScrollView,navBar:OOSegmentNavigationBar,cursor:UIView,newItem:UIButton,oldItem:UIButton);
    optional func scroll(scrollView:UIScrollView,navBar:OOSegmentNavigationBar,cursor:UIView,fullWidth:CGFloat,xScale:CGFloat,correctXScale:CGFloat,computeWidth:CGFloat,leftXOffset:CGFloat,centerXOffset:CGFloat,finished:Bool);
}


public class OOCursorMoveEffect: CursorMoveEffect {

    @objc public func scroll(scrollView: UIScrollView, navBar: OOSegmentNavigationBar, cursor: UIView, newItem: UIButton, oldItem: UIButton) {
        let fullWidth = CGRectGetWidth(scrollView.frame)
        let button = newItem , oldButton = oldItem
        
        let xScale = scrollView.contentOffset.x % fullWidth / fullWidth
        
        let indicatorWidth = button.frame.size.width // titleWidthAtFont(titleFont, index: index)
        let oldWidth = oldButton.frame.size.width // titleWidthAtFont(titleFont, index: oldIndex)
        let f = CGFloat(newItem.tag - oldItem.tag)
        var s = (f > 0 ? 1.0 - (xScale == 0 ? 1.0 : xScale) : xScale) // == 1.0 ? xScale : 0
        s = s < 0.01 || s > 0.99 ? round(s) : s
        let w = (oldWidth - indicatorWidth) * s + indicatorWidth
        let xOffset = (oldButton.center.x - button.center.x) * s
        let x = xOffset + button.center.x
        //        print(xOffset)
        //        print("nx:\(button.center.x)    ox:\(oldButton.center.x)  x:\(x)   f:\(f)     s:\(s)  xs:\(xScale)")
        
        
        cursor.frame.size.width = w
        cursor.center.x = x
        if navBar.contentSize.width > fullWidth {
            UIView.animateWithDuration(0.3) {
                if CGRectGetMaxX(navBar.bounds) < CGRectGetMaxX(button.frame) + 2 {
                    navBar.contentOffset.x += (CGRectGetMaxX(button.frame) - CGRectGetMaxX(navBar.bounds) + 2) + navBar.itemOffset
                } else if CGRectGetMinX(navBar.bounds) > CGRectGetMinX(button.frame) - 2 {
                    navBar.contentOffset.x = CGRectGetMinX(button.frame) - 2 - navBar.itemOffset
                }
            }
        }
    }
    
}

public class OOCursorCenterMoveEffect : CursorMoveEffect {
    
    @objc public func scroll(scrollView: UIScrollView, navBar: OOSegmentNavigationBar, cursor: UIView, newItem: UIButton, oldItem: UIButton) {
        let fullWidth = CGRectGetWidth(scrollView.frame)
        let button = newItem , oldButton = oldItem
        
        let xScale = scrollView.contentOffset.x % fullWidth / fullWidth
        
        let indicatorWidth = button.frame.size.width // titleWidthAtFont(titleFont, index: index)
        let oldWidth = oldButton.frame.size.width // titleWidthAtFont(titleFont, index: oldIndex)
        let f = CGFloat(newItem.tag - oldItem.tag)
        var s = (f > 0 ? 1.0 - (xScale == 0 ? 1.0 : xScale) : xScale) // == 1.0 ? xScale : 0
        s = s < 0.01 || s > 0.99 ? round(s) : s
        let w = (oldWidth - indicatorWidth) * s + indicatorWidth
        let xOffset = (oldButton.center.x - button.center.x) * s
        let x = xOffset + button.center.x
        //        print(xOffset)
        //        print("nx:\(button.center.x)    ox:\(oldButton.center.x)  x:\(x)   f:\(f)     s:\(s)  xs:\(xScale)")
        
        
        cursor.frame.size.width = w
        cursor.center.x = x
        if navBar.contentSize.width > fullWidth {
                var offset = CGFloat(0)
                if button.center.x < fullWidth / 2.0 || button.center.x > navBar.contentSize.width - fullWidth / 2.0 {
                    offset = button.center.x < fullWidth / 2.0  ? fullWidth / 2.0 - button.center.x : navBar.contentSize.width - fullWidth / 2.0 -  button.center.x
                }
                UIView.animateWithDuration(0.3) {
                    navBar.contentOffset.x = button.center.x - fullWidth / 2.0 + offset
                }
        }
    }
    
}


public class OOCursorLeftDockMoveEffect : CursorMoveEffect {
    
    public var leftMargin : CGFloat
    var lastOffset = CGFloat(0)
    init(leftMargin:CGFloat = 40) {
        self.leftMargin = leftMargin
    }
    
//    @objc public func scroll(scrollView: UIScrollView, navBar: OOSegmentNavigationBar, cursor: UIView, newItem: UIButton, oldItem: UIButton) {
//        let fullWidth = CGRectGetWidth(scrollView.frame)
//        let button = newItem , oldButton = oldItem
//        
//        let xScale = scrollView.contentOffset.x % fullWidth / fullWidth
//        
//        let indicatorWidth = button.frame.size.width // titleWidthAtFont(titleFont, index: index)
//        let oldWidth = oldButton.frame.size.width // titleWidthAtFont(titleFont, index: oldIndex)
//        let f = CGFloat(newItem.tag - oldItem.tag)
//        var s = (f > 0 ? 1.0 - (xScale == 0 ? 1.0 : xScale) : xScale) // == 1.0 ? xScale : 0
//        s = s < 0.01 || s > 0.99 ? round(s) : s
//        let w = round((oldWidth - indicatorWidth) * s + indicatorWidth)
//        let xOffset = round((oldButton.frame.origin.x - button.frame.origin.x) * s)
//        let x = xOffset + button.frame.origin.x
//        
//        cursor.frame.size.width = w
//        cursor.frame.origin.x = x
//        if navBar.contentSize.width > fullWidth {
//            let targetX = x - navBar.itemMargin - leftMargin
//            if targetX <= navBar.contentSize.width - fullWidth && targetX >= 0 {
//                navBar.contentOffset.x = targetX
//            }
//        }
//        
//    }
    
    @objc public func scroll(scrollView: UIScrollView, navBar: OOSegmentNavigationBar, cursor: UIView, fullWidth: CGFloat, xScale: CGFloat, correctXScale: CGFloat, computeWidth: CGFloat, leftXOffset: CGFloat, centerXOffset: CGFloat, finished: Bool) {
        cursor.frame.size.width = computeWidth
        cursor.frame.origin.x = leftXOffset
        if navBar.contentSize.width > fullWidth {
            let targetX = leftXOffset - navBar.itemMargin - leftMargin
            if targetX <= navBar.contentSize.width - fullWidth && targetX >= 0 {
                navBar.contentOffset.x = targetX
            }
        }
    }
}
