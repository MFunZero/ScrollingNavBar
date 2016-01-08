//
//  Cover.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/29.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class Cover: CALayer {
    let rwColor = UIColor.whiteColor()
    
    let rwPath = UIBezierPath()
    let rwLayer = CAShapeLayer()
    
    // 2
    func setUpRWPath(lowerValueCenter: CGFloat,thumbWidth:CGFloat) {
        
        print("\(thumbWidth)")
        rwPath.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 18.0, startAngle: CGFloat(M_PI * 0.50), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        rwPath.moveToPoint(CGPointMake( 0.0,0.0 ))
        rwPath.addLineToPoint(CGPointMake(thumbWidth / 9.0, thumbWidth / 3))
        rwPath.addLineToPoint(CGPointMake(thumbWidth / 4.0, thumbWidth / 6))
        rwPath.addArcWithCenter(CGPoint(x: thumbWidth / 2.0, y: lowerValueCenter), radius: 18.0, startAngle: CGFloat(M_PI * 0.50), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
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