//
//  CollectionViewController.swift
//  OOSegmentViewController
//
//  Created by lee on 16/8/3.
//  Copyright © 2016年 clearlove. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
}

class CollectionView: UICollectionView {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
        let view = UIView(frame: CGRect(x: 0, y: -200, width: 414, height: 200))
        view.backgroundColor = UIColor.redColor()
        self.addSubview(view)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print("\(touches)       \(event)")
        super.touchesEnded(touches, withEvent: event)
    }
}

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 50
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OOCollectionCell", forIndexPath: indexPath) as! CollectionCell
    
        // Configure the cell
        cell.title.text = "Index \(indexPath.item)"
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath)")
    }
    // MARK: UICollectionViewDelegate

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("\(touches)       \(event)")
        super.touchesEnded(touches, withEvent: event)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        parentViewController?.followScrollView(scrollView)
    }

}
