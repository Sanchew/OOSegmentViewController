//
//  OOSegmentViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit


@objc public protocol OOSegmentDelegate {
    
    @objc optional func segmentViewController(_ segmentViewController:OOSegmentViewController,willShowViewController viewController:UIViewController) -> Void;
    @objc optional func segmentViewController(_ segmentViewController:OOSegmentViewController,didShowViewController viewController:UIViewController) -> Void;
    
}



open class OOSegmentViewController : UIPageViewController {
    
//    private var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    open var navBar = OOSegmentNavigationBar()
    fileprivate var navBarHideAnimate = false
    fileprivate var lastContentOffset = CGFloat(0)
    fileprivate var lastScrollDirection = UIAccessibilityScrollDirection.up
    fileprivate var scrollDistance = CGFloat(0)
    
    open var navBarTopLayoutConstraint : NSLayoutConstraint!
    
    open var navBarHeight = CGFloat(40)
    open var segmentDelegate : OOSegmentDelegate?
    open var titleColor = UIColor.black
    open var titleSelectedColor = UIColor.red
    open var fontSize = CGFloat(15)
    open var cursorColor = UIColor.white
    open var cursorHeight = CGFloat(2)
    open var cursorBottomMargin : CGFloat?
    open var navBarBackgroundColor = UIColor.white
    open var titleMargin = CGFloat(8)
    open var titleOffset = CGFloat(0)
    
    open var cursorMoveEffect : CursorMoveEffect = OOCursorMoveEffect()
    
    open var pageIndex = 0 {
        didSet {
//            if pageIndex != oldValue {
//                moveToControllerAtIndex(pageIndex)
//            }
            pendingIndex = pageIndex
        }
    }
    var pendingIndex = 0
    fileprivate var autoFetchTitles = false
    open var titles = [String]() {
        didSet {
            pageIndex = 0
            navBar.titles = titles
        }
    }
    open var controllers = [UIViewController]() {
        didSet {
            if let first = controllers.first,let vcs = self.viewControllers , !vcs.isEmpty {
                self.setViewControllers([first], direction: .forward, animated: false, completion: nil)
            }
            if autoFetchTitles {
                titles = controllers.map {
                    $0.title ?? ""
                }
            }
        }
    }
    
    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required public init?(coder: NSCoder) {
//        super.init(coder: coder)
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraints()
    }
    
    class PageControlView: UIView {
        var view:UIView
        init(view:UIView) {
            self.view = view
            super.init(frame:CGRect.zero)
            addSubview(view)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var pageControl:UIPageControl? {
            return view.value(forKey: "_pageControl") as? UIPageControl
        }
        
        var scrollView:UIScrollView {
            return view.value(forKey: "_scrollView") as! UIScrollView
        }
        
    }
    
    open func configUI(){
        self.view.backgroundColor = UIColor.white
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        
        if self.view.backgroundColor == nil {
            self.view.backgroundColor = UIColor.white
        }
        
        delegate = self
        dataSource = self
        
//        addChildViewController(pageViewController)
//        view.insertSubview(pageViewController.view, atIndex: 0)
//        pageViewController.didMoveToParentViewController(self)
       
        setViewControllers([controllers[pageIndex]], direction: .forward, animated: false, completion: nil)
        
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
        
        if let scrollView = self.value(forKey: "_scrollView") as? UIScrollView {
            scrollView.delegate = navBar
            scrollView.scrollsToTop = false
        }
        
        let view = PageControlView(view: self.view)
        self.view = view
        view.addSubview(navBar)
        
    }
    
    open func configConstraints() {
        let views = ["navBar":navBar,"pageView":(self.view as! PageControlView).view]
        //        let views = ["navBar":navBar,"pageView":view]
        views.forEach {
            $1.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[navBar]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageView]|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[navBar(\(navBarHeight))][pageView]|", options: .directionLeadingToTrailing, metrics: nil, views: views)
        navBarTopLayoutConstraint = constraints.first!
        view.addConstraints(constraints)
 
    }
    
    public func moveToControllerAtIndex(index:Int, animated : Bool = true){
        guard index >= 0 && index < controllers.count else {
            return
        }
        let direction : UIPageViewControllerNavigationDirection = index > pageIndex ? .forward : .reverse
        pendingIndex = index
        viewControllerWillShow()
        if pageIndex == pendingIndex {
            viewControllerDidShow()
            return
        }
        setViewControllers([controllers[index]], direction: direction, animated: animated) { [weak self] completed in
            if completed {
                self?.viewControllerDidShow()
//                self?.pendingIndex = -1
            }
        }
    }
    
    func viewControllerWillShow() {
        
        segmentDelegate?.segmentViewController?(self, willShowViewController: (viewControllers?.last)!)
    }
    
    func viewControllerDidShow() {
//        self.pageIndex = self.pendingIndex
        scrollDistance = 0
        lastContentOffset = 0
        self.pageIndex = getFocusViewControllerIndex()
        navBar.updateSelectItem(self.pageIndex)
        setNavBarHidden(false,animated:false)
        segmentDelegate?.segmentViewController?(self, didShowViewController: (viewControllers?.last)!)
    }
    
    open func setNavBarHidden(_ hidden: Bool , animated : Bool = true) {
        guard hidden || self.navBarTopLayoutConstraint.constant != 0 else {
            return
        }
        navBarHideAnimate = true
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            if 8 == ProcessInfo().operatingSystemVersion.majorVersion {
                var frame = self.view.subviews[0].frame
                frame.size.height += self.navBarHeight * (hidden ? 1 : -1)
                self.view.subviews[0].frame = frame
            }
            if (animated) {
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 1.0, animations: {
                    self.navBarTopLayoutConstraint.constant = hidden ? -self.navBarHeight : 0
                    self.view.layoutIfNeeded()
                })
            }else {
                self.navBarTopLayoutConstraint.constant = hidden ? -self.navBarHeight : 0
            }
        }, completion: { _ in
            self.navBarHideAnimate = false
        }) 
    }
    
    open func followScrollView(_ scrollView: UIScrollView,navBarHideChangeHandler:((Bool)->())? = nil) {
        let contentOffsetY = scrollView.contentOffset.y,
            topInset = scrollView.contentInset.top,
            buttomInset = scrollView.contentInset.bottom
        guard contentOffsetY >= 0 - topInset && contentOffsetY <= scrollView.contentSize.height + buttomInset - scrollView.bounds.height else { return }
        // 流动方向
        let direction: UIAccessibilityScrollDirection = (scrollView.contentOffset.y > lastContentOffset) ? .up : .down
        if direction == lastScrollDirection {
            scrollDistance += scrollView.contentOffset.y - lastContentOffset
        }else{
            lastScrollDirection = direction
            scrollDistance = 0
        }
        lastContentOffset = scrollView.contentOffset.y
//        print("distance \(scrollDistance) \(contentOffsetY)  \(scrollView.contentSize.height)")
//        if scrollView.tracking == true && abs(scrollDistance) > navBarHeight && navBarHideAnimate == false {
        if abs(scrollDistance) > navBarHeight && navBarHideAnimate == false {
            
            if direction == .up && self.navBarTopLayoutConstraint.constant == 0 {
                // 隐藏
                setNavBarHidden(true)
                navBarHideChangeHandler?(true)
            } else if direction == .down && self.navBarTopLayoutConstraint.constant == -navBarHeight {
                // 显示
                setNavBarHidden(false)
                navBarHideChangeHandler?(false)
            }
        }
    }
    
    func getFocusViewControllerIndex()->Int {
        return controllers.index(of: (viewControllers?.last)!)!
    }
}

extension OOSegmentViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func nextViewController(_ viewController:UIViewController,combine: (Int,Int)->Int) -> UIViewController? {
        let index = combine(controllers.index(of: viewController)!,1)
        guard (0..<controllers.count).contains(index) else {
            return nil
        }
        return controllers[index]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            viewControllerDidShow()
        } else {
            pendingIndex = pageIndex
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = controllers.index(of: pendingViewControllers.first!)!
        viewControllerWillShow()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: +)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: -)
    }
    
}
