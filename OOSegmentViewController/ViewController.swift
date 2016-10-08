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
        let button = UIButton(frame: CGRect(x: 0,y: 100,width: self.view.frame.width,height: 30))
        button.setTitle("Click ME", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
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
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc.titleOffset = 20
        vc.titleMargin = 30
        vc.controllers = [
            sb.instantiateViewController(withIdentifier: "CollectionViewController"),
            sb.instantiateViewController(withIdentifier: "TableViewController"),
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
        vc.cursorColor = UIColor.blue
        vc.titleSelectedColor = UIColor.blue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func createController() -> UIViewController {
        let vc = UIViewController()
        //vc.view.backgroundColor = UIColor(red: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), alpha: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)))
        return vc
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

