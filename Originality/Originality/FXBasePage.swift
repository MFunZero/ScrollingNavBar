//
//  FXBasePage.swift
//  Originality
//
//  Created by suze on 16/1/1.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class FXBasePage: FXBaseController {
    
    @IBOutlet var backView:UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setNavigationItem(title:String,
        selector:Selector,isRight:Bool)
    {
        let item:UIBarButtonItem?
        
        if title.hasSuffix("png") {
            item = UIBarButtonItem(image: UIImage(named: title), style: .Plain, target: self, action: selector)
        }
        else {
            item = UIBarButtonItem(title: title, style: .Plain, target: self, action: selector)
        }
        
        item?.tintColor = UIColor.darkGrayColor()
        
        if isRight {
            self.navigationItem.rightBarButtonItem = item
        }
        else {
            self.navigationItem.leftBarButtonItem = item
        }
    }
    
    func doRight()
    {
        
    }
    
    func doBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
