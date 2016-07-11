//
//  ViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/27.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton(frame: CGRectMake(0,100,CGRectGetWidth(self.view.frame),30))
        button.setTitle("Click ME", forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(clickAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }

    func clickAction() {
        let vc = OOSegmentViewController()
        vc.titles = [
            "WorkKKKK",
            "Job",
            "MaskLLLLL",
            "Life",
            "Live",
            "MissWWWWW",
            "GOHomeHHHH",
            "TESTSSSSSS",
            "TTT"
        ]
        let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        vc.titleOffset = 20
        vc.titleMargin = 30
        vc.controllers = [
            sb.instantiateViewControllerWithIdentifier("TableViewController"),
            createController(),
            createController(),
            createController(),
            createController(),
            createController(),
            createController(),
            createController()
        ]
        vc.navBarHeight = 44
        vc.cursorHeight = 4
        vc.cursorBottomMargin = 0
//        vc.pageIndex = 3
        vc.cursorMoveEffect = OOCursorLeftDockMoveEffect()
        vc.cursorColor = UIColor.blueColor()
        vc.titleSelectedColor = UIColor.blueColor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func createController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(red: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), alpha: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)))
        return vc
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

