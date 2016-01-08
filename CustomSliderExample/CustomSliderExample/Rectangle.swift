//
//  Rectangle.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/28.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class Rectangle: CALayer {
    // 1
        let rwColor = UIColor.whiteColor()
    
        let rwPath = UIBezierPath()
        let rwLayer = CAShapeLayer()
        
        // 2
    func setUpRWPath(thumbWidth:CGFloat) {
    
        print("\(thumbWidth)")
            rwPath.moveToPoint(CGPointMake( thumbWidth / 9.0,thumbWidth / 12.0 ))
            rwPath.addLineToPoint(CGPointMake(thumbWidth / 9.0, thumbWidth / 4))
            rwPath.addLineToPoint(CGPointMake(thumbWidth / 4.0, thumbWidth / 6))

            rwPath.closePath()
        }
        
        // 3
        func setUpRWLayer() {
            rwLayer.path = rwPath.CGPath
            rwLayer.fillColor = rwColor.CGColor
            rwLayer.fillRule = kCAFillRuleNonZero
            rwLayer.lineCap = kCALineCapButt
            rwLayer.lineDashPattern = nil
            rwLayer.lineDashPhase = 0.0
            rwLayer.lineJoin = kCALineJoinMiter
            rwLayer.lineWidth = 1.0 
            rwLayer.miterLimit = 10.0 
            rwLayer.strokeColor = rwColor.CGColor 
        } 
        
  
        
}