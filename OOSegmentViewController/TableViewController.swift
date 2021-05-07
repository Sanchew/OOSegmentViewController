//
//  TableViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/7/1.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "Index \((indexPath as NSIndexPath).row)"
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if let segment = self.parent {
//            segment.followScrollView(scrollView)
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
