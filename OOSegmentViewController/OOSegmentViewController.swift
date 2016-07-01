//
//  OOSegmentViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

public class OOSegmentViewController : UIViewController {
    
    private var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private var navBar = OOSegmentNavigationBar()
    private var navBarHeight = 40
    
    
    var titleColor = UIColor.blackColor()
    var titleSelectedColor = UIColor.redColor()
    var fontSize = 15 as CGFloat
    var cursorColor = UIColor.whiteColor()
    var navBarBackgroundColor = UIColor.whiteColor()
    
    var pageIndex = 0 {
        didSet {
//            if pageIndex != oldValue {
//                moveToControllerAtIndex(pageIndex)
//            }
        }
    }
    var pendingIndex = -1
    var titles = [String]() {
        didSet {
//            print(titles)
        }
    }
    var controllers = [UIViewController]() {
        didSet {
//            print(controllers)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI(){
        
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
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[navBar(\(navBarHeight))][pageView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        
        
        pageViewController.setViewControllers([controllers[pageIndex]], direction: .Forward, animated: false, completion: nil)
        navBar.backgroundColor = navBarBackgroundColor
        navBar.titleColor = titleColor
        navBar.titleSelectedColor = titleSelectedColor
        navBar.cursorColor = cursorColor
        navBar.fontSize = fontSize
        navBar.titles = titles
        navBar.segmentViewController = self
        
        if let scrollView = pageViewController.view.subviews.first as? UIScrollView {
            scrollView.delegate = navBar
        }
        
    }
    
    func moveToControllerAtIndex(index:Int, animated : Bool = true){
        
        let direction : UIPageViewControllerNavigationDirection = index > pageIndex ? .Forward : .Reverse
        pendingIndex = index
        pageViewController.setViewControllers([controllers[index]], direction: direction, animated: animated) { [weak self] completed in
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

