//
//  CollectionViewTest.swift
//  CollectionView
//
//  Created by suze on 15/12/5.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class CustomLayout:  UICollectionViewLayout{
    //setting for inserts设置collectionview的cell边距
    var left:CGFloat = 5
    var right:CGFloat = 5.0
    var top:CGFloat = 5.0
    var bottom:CGFloat = 5.0
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func collectionViewContentSize() -> CGSize {
        let width = (self.collectionView!.bounds.width) / CGFloat((self.collectionView?.numberOfItemsInSection(0))! * 2 )
        return CGSize(width: (collectionView?.frame.width)!, height: 2 * (width) + 200)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        let cellCount = self.collectionView!.numberOfItemsInSection(0)
        for i in 0 ..< cellCount {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
            attributesArray.append(attributes!)
        }
      
      
        let index = self.collectionView!.indexOfAccessibilityElement(UICollectionElementKindSectionHeader)
        print("index:\(index)")
        let  attr:UICollectionViewLayoutAttributes = self.collectionView!.layoutAttributesForSupplementaryElementOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: index, inSection: 0))!
            attributesArray.append(attr)
        
    
        return attributesArray
        
    }
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let cellCountInline = self.collectionView!.numberOfItemsInSection(0) / 2
        
        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        let lineSpacing = 5
       
        let insets = UIEdgeInsetsMake(top, left, bottom, right)

        let largeCellSide:CGFloat = self.collectionView!.bounds
            .width/CGFloat(cellCountInline) - insets.left - insets.right
        
        let smallCellSide:CGFloat = largeCellSide + 40
        
        //当前行数
        let lines = indexPath.item / ((self.collectionView?.numberOfItemsInSection(0))!/2)
        
        //当前行y坐标
        let lineOriginY = (smallCellSide) * CGFloat(lines) + CGFloat(lineSpacing * lines) 
        
        //右侧单元格X坐标
        let rightLargeX =  (largeCellSide + insets.right + insets.left)
        
       
            for j in 0 ..< cellCountInline {
                
                if (indexPath.item % cellCountInline == j) {
                   
                    attribute.frame = CGRectMake(insets.left + rightLargeX * CGFloat(j), lineOriginY + 40 , largeCellSide,smallCellSide)
                }
            }
       
//        if (cellCountInline == 1 || cellCountInline == 3){
//        if (indexPath.item % 6 == 0) {
//            attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,smallCellSide)
//        } else if (indexPath.item % 6 == 1) {
//            attribute.frame = CGRectMake(rightLargeX  + insets.left, lineOriginY, largeCellSide,
//                smallCellSide)
//        } else if (indexPath.item % 6 == 2) {
//            attribute.frame = CGRectMake(rightLargeX * 2  + insets.left,
//                lineOriginY , largeCellSide, smallCellSide)
//            
//        } else if (indexPath.item % 6 == 3) {
//            attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,
//                smallCellSide )
//        } else if (indexPath.item % 6 == 4) {
//            attribute.frame = CGRectMake(rightLargeX + insets.left,
//                lineOriginY , largeCellSide, smallCellSide)
//        } else if (indexPath.item % 6 == 5) {
//            attribute.frame = CGRectMake(rightLargeX * 2  + insets.left, lineOriginY, largeCellSide,
//                smallCellSide)
//        }
//        } else if (cellCountInline == 2 ){
//            
//            if (indexPath.item % 6 == 0) {
//                attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,smallCellSide)
//            } else if (indexPath.item % 6 == 1) {
//                attribute.frame = CGRectMake(rightLargeX  + insets.left, lineOriginY, largeCellSide,
//                    smallCellSide)
//            }  else if (indexPath.item % 6 == 2) {
//                attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,
//                    smallCellSide )
//            } else if (indexPath.item % 6 == 3) {
//                attribute.frame = CGRectMake(rightLargeX + insets.left,
//                    lineOriginY , largeCellSide, smallCellSide)
//            }
//
//        }else if (cellCountInline == 4 ){
//            
//            if (indexPath.item % 8 == 0) {
//                attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,smallCellSide)
//            } else if (indexPath.item % 8 == 1) {
//                attribute.frame = CGRectMake(rightLargeX  + insets.left, lineOriginY, largeCellSide,
//                    smallCellSide)
//            } else if (indexPath.item % 8 == 2) {
//                attribute.frame = CGRectMake(rightLargeX * 2  + insets.left,
//                    lineOriginY , largeCellSide, smallCellSide)
//                
//            }else if (indexPath.item % 8 == 3) {
//                attribute.frame = CGRectMake(rightLargeX * 3  + insets.left,
//                    lineOriginY , largeCellSide, smallCellSide)
//                
//            }
//            else if (indexPath.item % 8 == 4) {
//                attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide,
//                    smallCellSide )
//            } else if (indexPath.item % 8 == 5) {
//                attribute.frame = CGRectMake(rightLargeX + insets.left,
//                    lineOriginY , largeCellSide, smallCellSide)
//            } else if (indexPath.item % 8 == 6) {
//                attribute.frame = CGRectMake(rightLargeX * 2  + insets.left, lineOriginY, largeCellSide,
//                    smallCellSide)
//            }
//            else if (indexPath.item % 8 == 7) {
//                attribute.frame = CGRectMake(rightLargeX * 3  + insets.left,
//                    lineOriginY , largeCellSide, smallCellSide)
//                
//            }
//            
//            
//        }
        return attribute
        
    }
    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
//        attribute.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), CGFloat(M_PI))
//        attribute.alpha = 0.5
//        
//        return attribute
//    }
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
       attribute.frame = CGRect(x: 0,y: 0,width: self.collectionView!.frame.width,height: 35)
        
         
        return attribute
    }
    
    
}