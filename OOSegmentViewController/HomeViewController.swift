//
//  HomeViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/6/28.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

class HomeViewController: OOSegmentViewController {

    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        titles = [
            "One",
            "Two",
            "HHHHHH"
        ]
        
        controllers = [
            createController(),
            createController(),
            createController()
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(action))
        
    }
    
    func action() {
        self.pageIndex = 2
    }
    
    
    func createController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(red: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)), alpha: CGFloat(CGFloat(random())/CGFloat(RAND_MAX)))
        return vc
    }

}
