//
//  BaseViewController.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
