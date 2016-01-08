//
//  RangeSlider.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/28.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit
import QuartzCore
class RangeSlider: UIControl {

    //

   
    
    var minimumValue: Double = 0.0 {
        
        didSet {
            
            updateLayerFrames()
        }
    }
    
    var maximumValue: Double = 1.0 {
        
        didSet {
            
            updateLayerFrames()
            
        }
    }
    
    var lowerValue: Double = 0.0 {
        
        didSet {
            
            updateLayerFrames()
            
        }
    }
    var upperValue: Double = 1.0 {
    
    didSet {
    
    updateLayerFrames()
    
    }
    }
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
        }
    }
//
    var trackHighlightTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
        }
    }
//
//    var thumbTintColor: UIColor = UIColor.whiteColor() {
//        
//        didSet {
//            
//            lowerThumbLayer.setNeedsDisplay()
//            
//            
//        }
//    }
//    
    
    var curvaceousness: CGFloat = 1.0 {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
            lowerThumbLayer.setNeedsDisplay()
            
            
        }
    }
    
    //用来熏染滑块控件的不同组件
    let trackLayer = RangeSliderThumbLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
   // let upperThumbLayer = RangeSliderThumbLayer()

    //   设置子图
    var childLayer = Rectangle()
    var pauseLayer = PauseLayer()
    var coverLayer = Cover()
    
    
    //update for frame when frame is changeing
    override  var frame: CGRect {
        didSet{
            updateLayerFrames()
        }
    }
    
    
    //布局使用
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    
    //跟踪记录用户的触摸位置
    var previousLocation = CGPoint()
    var lowerThumbCenter: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lowerThumbLayer.rangeSlider = self
        
//
        trackLayer.backgroundColor = UIColor.blueColor().CGColor
        trackLayer.cornerRadius = 18.0
        layer.addSublayer(trackLayer)
        print("layer:\(layer)")
        
        lowerThumbLayer.cornerRadius = 18.0
        lowerThumbLayer.borderColor = UIColor.whiteColor().CGColor
        lowerThumbLayer.borderWidth = 2.0
        
        //lowerThumbLayer.addSublayer(childLayer.rwLayer)
        
        lowerThumbLayer.addSublayer(pauseLayer.contentLay)
        layer.addSublayer(coverLayer)
       
        
        layer.addSublayer(lowerThumbLayer)
        
//        lowerThumbLayer.rangeSlider = self
//        upperThumbLayer.rangeSlider = self
        
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func updateLayerFrames(){
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        print("\(trackLayer.frame)")
        trackLayer.setNeedsDisplay()
        
        lowerThumbCenter = CGFloat(positionForValue(lowerValue))
       
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 3.0, y: bounds.height / 3.0, width: thumbWidth / 3.0 , height: thumbWidth / 3.0)
        print("lowerThumbLayer:\(lowerThumbLayer.frame)")
        lowerThumbLayer.setNeedsDisplay()
        
        
        childLayer.setUpRWPath(thumbWidth)
        childLayer.setUpRWLayer()
        pauseLayer.setUpRWPath(thumbWidth)
        pauseLayer.setUpRWLayer()
        coverLayer.setUpRWPath(lowerThumbCenter,thumbWidth: thumbWidth)
        coverLayer.setUpRWLayer()
        
        

     
    }
    
    func positionForValue(value: Double)->Double {
        print("bounds.width:\(bounds.width),thumbWidth:\(thumbWidth)")
        let  status = (value - minimumValue) / (maximumValue - minimumValue)
        print("\(status)")
        if status >= 1 {
             let db = Double(bounds.width - thumbWidth) * (value - minimumValue) /
               (maximumValue - minimumValue) + Double(thumbWidth)
             print("postion:\(db)")
             return db
        }else {
            let db =  Double(bounds.width - thumbWidth) * (value - minimumValue) /
                
                (maximumValue - minimumValue) + Double(thumbWidth / 6.0) + 20.0 - 2.5
        print("postion:\(db)")
        return db
        }
    }
  
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
  
        //Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation){
            lowerThumbLayer.heighlighted = true
        }
        
        
        return lowerThumbLayer.heighlighted
    }
    
    func boundValue( value: Double, toLowerValue lowerValue:Double,upperValue:Double)->Double{
      
        return min(max(value, lowerValue), upperValue)
    }
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        //
        let deltalocation = Double(location.x - previousLocation.x)
        let deltValue = (maximumValue - minimumValue) * deltalocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        if lowerThumbLayer.heighlighted {
            lowerValue += deltValue
            //
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: maximumValue)

        }
        //
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
        override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        lowerThumbLayer.heighlighted = false
    }
    
}
