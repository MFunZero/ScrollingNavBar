//
//  CollectionViewTest.swift
//  CollectionView
//
//  Created by suze on 15/12/5.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class CollectionViewTest: UICollectionView ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var count = 6
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let height = (screenWidth-16)*5/8 + 30
        let width = screenWidth/CGFloat(self.count) * 2
        return CGSize(width: width, height: height)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = CollectionViewCell()
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
}
