//
//  RangeSliderThumbLayer.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/28.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit
import QuartzCore
class RangeSliderThumbLayer: CALayer {

    var heighlighted: Bool = false {
        
        didSet {
            
            setNeedsDisplay()
            
        }
    }
    weak var rangeSlider: RangeSlider?
    
     override func drawInContext(ctx: CGContext) {
        
        
        if let slider = rangeSlider {
            
            // Clip
            
 
            print("Bezier\(bounds)")
            let cornerRadius = CGFloat(18)
            let rect1 = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: slider.lowerThumbCenter, height: bounds.height)
            let path = UIBezierPath(roundedRect: rect1, cornerRadius: cornerRadius)
            
            
            CGContextMoveToPoint(ctx, 20, 100);
            CGContextAddLineToPoint(ctx, 100, 320)
            CGContextAddPath(ctx, path.CGPath)
            
            
            
            // Fill the track
            
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            
            CGContextAddPath(ctx, path.CGPath)
            
            CGContextFillPath(ctx)
            
            
            
            // Fill the highlighted range
            
            CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
            
            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
        
            
            let rect = CGRect(x: 0.0, y: slider.thumbWidth / 3.0, width:lowerValuePosition, height: bounds.height)
            
            
            CGContextFillRect(ctx, rect)
    }
}
}