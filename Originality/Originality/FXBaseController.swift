//
//  FXBaseController.swift
//  Originality
//
//  Created by suze on 16/1/1.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class FXBaseController: ViewController {
    
    var activity:FxActivity?
    
    
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
    
    func showActivityInView(view:UIView)->FxActivity
    {
        let ac:FxActivity = FxActivityIndicator(view: view)
        
        ac.frame = view.bounds
        view.addSubview(ac)
        ac.labelText = ""
        
        return ac
    }
    
    func showIndicator(message:String,autoHide:Bool,
        afterDelay:Bool)
    {
        if activity == nil {
            activity = showActivityInView(self.view)
        }
        
        if message != "" {
            activity?.labelText = message
            activity?.show(false)
        }
        
        if autoHide && activity?.alpha>=1.0 {
            if afterDelay {
                activity?.hide(true, afterDelay: 1.0)
            }
            else {
                activity?.hide(true)
            }
        }
    }
    
    func hideIndicator()
    {
        activity?.hide(true)
    }
}
