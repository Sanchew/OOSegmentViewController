//
//  TableViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/7/1.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = "Index \(indexPath.row)"
        return cell
    }
    
}
