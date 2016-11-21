//
//  HomeViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/28.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

class HomeViewController: OOSegmentViewController{

    
    required init?(coder aDecoder: NSCoder) {
        print(aDecoder)
        super.init(coder: aDecoder)
        titles = [
            "Unused",
            "Expired",
            "Used",
            "Coupon Card"
        ]
        cursorMoveEffect = OOCursorLeftDockMoveEffect()
        controllers = [
            createController(),
            createController(),
            createController(),
            createController()
        ]
        cursorColor = UIColor.black
        titleMargin = 30
        pageIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(action(_:)))
    }
    
    func action(_ sender:UIButton) {
//        moveToControllerAtIndex(2,animated: false)
        let title = "what\(sender.tag)"
        sender.tag += 1
        titles += [title]
        controllers += [createController()]
        moveToControllerAtIndex(pageIndex)
    }
    
    
    func createController() -> UIViewController {
        let vc = UIViewController()
        //vc.view.backgroundColor = UIColor(red: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), alpha: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)))
        return vc
    }

}
