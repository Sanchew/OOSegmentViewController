//
//  OOSegmentViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

public class OOSegmentViewController : UIPageViewController {
    
//    private var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var scrollView : UIScrollView!
    private var navBar = OOSegmentNavigationBar()
    private var navBarHeight = 40 as CGFloat
    private var navBarHideAnimate = false
    private var lastContentOffset = CGFloat(0)
    
    public var titleColor = UIColor.blackColor()
    public var titleSelectedColor = UIColor.redColor()
    public var fontSize = 15 as CGFloat
    public var cursorColor = UIColor.whiteColor()
    public var navBarBackgroundColor = UIColor.whiteColor()
    
    public var pageIndex = 0 {
        didSet {
//            if pageIndex != oldValue {
//                moveToControllerAtIndex(pageIndex)
//            }
        }
    }
    var pendingIndex = -1
    public var titles = [String]() {
        didSet {
//            print(titles)
        }
    }
    public var controllers = [UIViewController]() {
        didSet {
//            print(controllers)
        }
    }
    
    public init () {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        delegate = self
        dataSource = self
        
        if let scrollView = view.subviews.first as? UIScrollView {
            scrollView.delegate = navBar
            self.scrollView = scrollView
        }
//        addChildViewController(pageViewController)
//        view.insertSubview(pageViewController.view, atIndex: 0)
//        pageViewController.didMoveToParentViewController(self)
//        
//        let views = ["navBar":navBar,"scrollView":scrollView]
//        
//        views.forEach {
//            $1.translatesAutoresizingMaskIntoConstraints = false
//        }
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[navBar]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[navBar(\(navBarHeight))][scrollView(300)]", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        
        
        setViewControllers([controllers[pageIndex]], direction: .Forward, animated: false, completion: nil)
        navBar.backgroundColor = navBarBackgroundColor
        navBar.titleColor = titleColor
        navBar.titleSelectedColor = titleSelectedColor
        navBar.cursorColor = cursorColor
        navBar.fontSize = fontSize
        navBar.titles = titles
        navBar.segmentViewController = self
        
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navBar.frame.size.width = CGRectGetWidth(view.frame)
        navBar.frame.size.height = navBarHeight
        scrollView.frame.origin.y = navBarHeight
        scrollView.frame.size.height -= navBarHeight
    }
    
    public func moveToControllerAtIndex(index:Int, animated : Bool = true){
        
        let direction : UIPageViewControllerNavigationDirection = index > pageIndex ? .Forward : .Reverse
        pendingIndex = index
        setViewControllers([controllers[index]], direction: direction, animated: animated) { [weak self] completed in
            if completed {
                self?.pageIndex = self!.pendingIndex
                self?.pendingIndex = -1
            }
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
            pageIndex = pendingIndex
        }
        pendingIndex = -1
    }
    
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        pendingIndex = controllers.indexOf(pendingViewControllers.first!)!
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: +)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, combine: -)
    }
    
}

extension OOSegmentViewController : UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tracking == true && abs(scrollView.contentOffset.y) >= navBarHeight && navBarHideAnimate == false {
            let up = (scrollView.contentOffset.y > lastContentOffset) ? true : false
            lastContentOffset = scrollView.contentOffset.y
            if up && CGRectGetMinY(navBar.frame) == 0 {
                navBarHideAnimate = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.navBar.frame.origin.y = -self.navBarHeight
                    self.scrollView.frame.origin.y = 0
                    self.scrollView.frame.size.height += self.navBarHeight
//                    .view.layoutIfNeeded()
//                    self.tableView.contentInset.top = 0
//                    self.view.layoutIfNeeded()
                    }, completion: { _ in
                        self.navBarHideAnimate = false
                })
            } else if !up && CGRectGetMinY(navBar.frame) == -navBarHeight {
                navBarHideAnimate = true
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.navBar.frame.origin.y = 0
                    self.scrollView.frame.origin.y = self.navBarHeight
                    self.scrollView.frame.size.height -= self.navBarHeight
                    }) { _ in
                        self.navBarHideAnimate = false
                }
            }
        }
        
    }
}

