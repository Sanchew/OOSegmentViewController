//
//  OOSegmentViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit


@objc public protocol OOSegmentDelegate {
    
    optional func segmentViewController(segmentViewController:OOSegmentViewController,willShowViewController viewController:UIViewController) -> Void;
    optional func segmentViewController(segmentViewController:OOSegmentViewController,didShowViewController viewController:UIViewController) -> Void;
    
}

public class OOSegmentViewController : UIViewController {
    
    private var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var navBar = OOSegmentNavigationBar()
    private var navBarHideAnimate = false
    private var lastContentOffset = CGFloat(0)
    private var navBarTopLayoutConstraint : NSLayoutConstraint!
    
    public var navBarHeight = CGFloat(40)
    public var delegate : OOSegmentDelegate?
    public var titleColor = UIColor.blackColor()
    public var titleSelectedColor = UIColor.redColor()
    public var fontSize = CGFloat(15)
    public var cursorColor = UIColor.whiteColor()
    public var cursorHeight = CGFloat(2)
    public var cursorBottomMargin : CGFloat?
    public var navBarBackgroundColor = UIColor.whiteColor()
    public var titleMargin = CGFloat(8)
    public var titleOffset = CGFloat(0)
    
    public var cursorMoveEffect : CursorMoveEffect = OOCursorMoveEffect()
    
    public var pageIndex = 0 {
        didSet {
//            if pageIndex != oldValue {
//                moveToControllerAtIndex(pageIndex)
//            }
            pendingIndex = pageIndex
        }
    }
    var pendingIndex = 0
    private var autoFetchTitles = false
    public var titles = [String]() {
        didSet {
            navBar.titles = titles
        }
    }
    public var controllers = [UIViewController]() {
        didSet {
//            print(controllers)
            if autoFetchTitles {
                titles = controllers.map {
                    $0.title ?? ""
                }
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    public func configUI(){
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        view.addSubview(navBar)
        
        if view.backgroundColor == nil {
            view.backgroundColor = UIColor.whiteColor()
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        view.insertSubview(pageViewController.view, atIndex: 0)
        pageViewController.didMoveToParentViewController(self)
        
        let views = ["navBar":navBar,"pageView":pageViewController.view]
        views.forEach {
            $1.translatesAutoresizingMaskIntoConstraints = false
        }
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[navBar]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[navBar(\(navBarHeight))][pageView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        navBarTopLayoutConstraint = constraints.first!
        self.view.addConstraints(constraints)
        
        
        pageViewController.setViewControllers([controllers[pageIndex]], direction: .Forward, animated: false, completion: nil)
        navBar.backgroundColor = navBarBackgroundColor
        navBar.titleColor = titleColor
        navBar.titleSelectedColor = titleSelectedColor
        navBar.cursorColor = cursorColor
        navBar.cursorHeight = cursorHeight
        navBar.cursorBottomMargin = cursorBottomMargin
        navBar.fontSize = fontSize
        navBar.segmentViewController = self
        if titles.count == 0 {
            autoFetchTitles = true
            controllers.forEach {
                titles.append($0.title ?? "")
            }
        }
        navBar.titles = titles
        navBar.itemMargin = titleMargin
        navBar.itemOffset = titleOffset
        navBar.moveEffect = cursorMoveEffect
        
        if let scrollView = pageViewController.view.subviews.first as? UIScrollView {
            scrollView.delegate = navBar
        }
        
    }
    
    public func moveToControllerAtIndex(index:Int, animated : Bool = true){
        guard index >= 0 && index < controllers.count else {
            return
        }
        let direction : UIPageViewControllerNavigationDirection = index > pageIndex ? .Forward : .Reverse
        pendingIndex = index
        viewControllerWillShow()
        if pageIndex == pendingIndex {
            viewControllerDidShow()
            return
        }
        pageViewController.setViewControllers([controllers[index]], direction: direction, animated: animated) { [weak self] completed in
            if completed {
                self?.viewControllerDidShow()
//                self?.pendingIndex = -1
            }
        }
    }
    
    func viewControllerWillShow() {
        
        delegate?.segmentViewController?(self, willShowViewController: (pageViewController.viewControllers?.last)!)
    }
    
    func viewControllerDidShow() {
//        self.pageIndex = self.pendingIndex
        self.pageIndex = getFocusViewControllerIndex()
        navBar.updateSelectItem(self.pageIndex)
        setNavBarHidden(false,animated:false)
        delegate?.segmentViewController?(self, didShowViewController: (pageViewController.viewControllers?.last)!)
    }
    
    func setNavBarHidden(hidden: Bool , animated : Bool = true) {
        guard hidden || self.navBarTopLayoutConstraint.constant != 0 else {
            return
        }
        navBarHideAnimate = true
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.navBarTopLayoutConstraint.constant = hidden ? -self.navBarHeight : 0
            if (animated) {
                self.view.layoutIfNeeded()
            }
        }) { _ in
            self.navBarHideAnimate = false
        }
    }
    
    public override func followScrollView(scrollView: UIScrollView) {
        
        if scrollView.tracking == true && abs(scrollView.contentOffset.y) >= navBarHeight && navBarHideAnimate == false {
            let up = (scrollView.contentOffset.y > lastContentOffset) ? true : false
            if up && self.navBarTopLayoutConstraint.constant == 0 && scrollView.contentOffset.y > 0 {
                setNavBarHidden(true)
            } else if !up && self.navBarTopLayoutConstraint.constant == -navBarHeight {
                setNavBarHidden(false)
            }
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func getFocusViewControllerIndex()->Int {
        return controllers.indexOf((pageViewController.viewControllers?.last)!)!
    }
    
}
// XXX:
extension UIViewController {
    
    public func followScrollView(scrollView: UIScrollView) {
        if let segment = self.parentViewController as? OOSegmentViewController {
            segment.followScrollView(scrollView)
        }
    }
    
}

extension OOSegmentViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func nextViewController(viewController:UIViewController,combine: (Int,Int)->Int) -> UIViewController? {
        let index = combine(controllers.indexOf(viewController)!,1)
        guard (0..<controllers.count).contains(index) else {
            return nil
        }
        return controllers[index]
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            viewControllerDidShow()
        } else {
            // XXX: 有一个回弹问题吧
            pendingIndex = pageIndex
        }
//        pageViewController.view.userInteractionEnabled = true
//        pendingIndex = -1
    }
    
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        pendingIndex = controllers.indexOf(pendingViewControllers.first!)!
        viewControllerWillShow()
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: +)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: -)
    }
    
}
