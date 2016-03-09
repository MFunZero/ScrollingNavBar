//
//  SearchResultViewLayout.swift
//  Originality
//
//  Created by fanzz on 16/3/9.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SearchResultViewLayout: UICollectionViewLayout {
 
    //setting for inserts设置collectionview的cell边距
    var left:CGFloat = 10.0
    var right:CGFloat = 5.0
    var top:CGFloat = 10.0
    var bottom:CGFloat = 0
    var countInLine = 2
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    override func collectionViewContentSize() -> CGSize {
    let height = ((self.collectionView!.bounds.width) / CGFloat(countInLine) ) * 1.8 * CGFloat(self.collectionView!.numberOfItemsInSection(0) / countInLine)
    
    return CGSize(width: (collectionView?.frame.width)!, height: height)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributesArray = [UICollectionViewLayoutAttributes]()
    
    let cellCount = self.collectionView!.numberOfItemsInSection(0)
    print("cellcount:\(cellCount)")
    for i in 0 ..< cellCount {
    let indexPath = NSIndexPath(forItem: i, inSection: 0)
    let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
    attributesArray.append(attributes!)
    }
    
   
    
    
    return attributesArray
    
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    //        let cellCountInline = self.collectionView!.numberOfItemsInSection(0) / 2
    
    let cellCountInline = countInLine
    
    let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    
    
    
    
    let largeCellSide:CGFloat = self.collectionView!.bounds.width / CGFloat(countInLine) - left - right
    
    let smallCellSide:CGFloat = (self.collectionView!.bounds.width / CGFloat(countInLine) ) * 1.8
    
    //当前行数
    let lines = indexPath.item / countInLine
    
    //当前行y坐标
    let lineOriginY = (smallCellSide) * CGFloat(lines) + top
    
    //右侧单元格X坐标
    var rightLargeX =  CGFloat(10)
    if indexPath.item % countInLine == 1 {
    rightLargeX =  largeCellSide + left + right * 2

    }
    
    
    if indexPath.item < self.collectionView!.numberOfItemsInSection(0) {
    attribute.frame = CGRect(x: rightLargeX, y: lineOriginY  , width: largeCellSide,height: smallCellSide - top - bottom)
    
    
    }
    return attribute
    
    }
    
  }