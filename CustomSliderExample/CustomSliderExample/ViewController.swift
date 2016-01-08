//
//  ViewController.swift
//  CustomSliderExample
//
//  Created by suze on 15/10/28.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rangeSlider = RangeSlider(frame:CGRectZero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rangeSlider.backgroundColor = UIColor.redColor()
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            self.rangeSlider.trackHighlightTintColor = UIColor.redColor()
            
            self.rangeSlider.curvaceousness = 0.0
            
        }
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider){
        print("rangeSliderValueChanged:\(rangeSlider.lowerValue)")
    }

    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x:margin,y:margin + topLayoutGuide.length,width:width,height:100.0)
        print("view.bounds:\(view.bounds.width)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

