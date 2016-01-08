//
//  PauseLayer.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/28.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class PauseLayer: CALayer {
    let rwColor = UIColor.whiteColor()
    
   
    let contentslayer = CAShapeLayer()
    let contentLay = CAShapeLayer()
    let rwPath = UIBezierPath()
    let rwPath1 = UIBezierPath()
    let rwLayer = CAShapeLayer()
    
    // 2
    func setUpRWPath(thumbWidth:CGFloat) {
        
        print("\(thumbWidth)")
        
        rwPath.moveToPoint(CGPointMake( thumbWidth / 8.0,thumbWidth / 12.0 ))
        
        rwPath.addLineToPoint(CGPointMake(thumbWidth / 8.0 + 2, thumbWidth / 12))
        rwPath.addLineToPoint(CGPointMake(thumbWidth / 8.0 + 2, thumbWidth / 4))
        rwPath.addLineToPoint(CGPointMake(thumbWidth / 8.0, thumbWidth / 4))
        rwPath.closePath()
        
        rwPath1.moveToPoint(CGPointMake( thumbWidth / 8.0+8,thumbWidth / 12.0 ))
        
        rwPath1.addLineToPoint(CGPointMake(thumbWidth / 8.0 + 10, thumbWidth / 12))
        rwPath1.addLineToPoint(CGPointMake(thumbWidth / 8.0 + 10, thumbWidth / 4))
        rwPath1.addLineToPoint(CGPointMake(thumbWidth / 8.0 + 8, thumbWidth / 4))
        
        rwPath1.closePath()
    }
    
    // 3
    func setUpRWLayer() {
        rwLayer.path = rwPath.CGPath
        rwLayer.fillColor = rwColor.CGColor
//        rwLayer.fillRule = kCAFillRuleNonZero
//        rwLayer.lineCap = kCALineCapButt
//        rwLayer.lineDashPattern = nil
//        rwLayer.lineDashPhase = 0.0
//        rwLayer.lineJoin = kCALineJoinMiter
//        rwLayer.lineWidth = 1.0
//        rwLayer.miterLimit = 10.0
//        rwLayer.strokeColor = rwColor.CGColor
        
        contentslayer.path = rwPath1.CGPath
        contentslayer.fillColor = rwColor.CGColor
//        contentslayer.fillRule = kCAFillRuleNonZero
//        contentslayer.lineCap = kCALineCapButt
//        contentslayer.lineDashPattern = nil
//        contentslayer.lineDashPhase = 0.0
//        contentslayer.lineJoin = kCALineJoinMiter
//        contentslayer.lineWidth = 1.0
//        contentslayer.miterLimit = 10.0
//        contentslayer.strokeColor = rwColor.CGColor
        
        
        contentLay.addSublayer(contentslayer)
        contentLay.addSublayer(rwLayer)
    }
    
    

}
