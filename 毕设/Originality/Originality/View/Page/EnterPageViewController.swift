//
//  EnterPageViewController.swift
//  Originality
//
//  Created by suze on 16/2/3.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class EnterPageViewController: UIViewController {

    var loginButton:UIButton!
    var regesiterButton:UIButton!
    
    var cancelButton:UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        configForView()
        // Do any additional setup after loading the view.
    }

    func configForView()
    {
        let imageBG = UIImageView(frame: self.view.frame)
        imageBG.image = UIImage(named: "loginBG")
        self.view.addSubview(imageBG)
        
        cancelButton = UIButton(frame: CGRect(x: 10, y: 30, width: 20, height: 20))
        self.view.addSubview(cancelButton)
        cancelButton.setBackgroundImage(UIImage(named: "cancel"), forState: .Normal)
        cancelButton.addTarget(self, action: "userClick:", forControlEvents: .TouchUpInside)
        
        loginButton = UIButton(frame: CGRect(x: 10, y: self.view.frame.height - 200, width: screenWidth - 20, height: 44))
        loginButton.backgroundColor = contentColor
        loginButton.layer.cornerRadius = 4.0
        loginButton.setTitle("登陆", forState: .Normal)
        loginButton.setTitleColor(maincolor, forState: .Normal)
        loginButton.addTarget(self, action: "loginButtonClick:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loginButton)
        
        
        regesiterButton = UIButton(frame: CGRect(x: 10, y: self.view.frame.height - 146, width: screenWidth - 20, height: 44))
        
        //regesiterButton.alpha = 0.3
        regesiterButton.layer.cornerRadius = 4.0
        regesiterButton.layer.borderWidth = 1
        regesiterButton.layer.borderColor = contentColor.CGColor
        regesiterButton.setTitle("注册", forState: .Normal)
        regesiterButton.setTitleColor(contentColor, forState: .Normal)
        regesiterButton.addTarget(self, action: "regesiterButtonClick:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(regesiterButton)
        
    }
    
 
    func loginButtonClick(sender:UIButton)
    {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func userClick(sender:UIButton)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func regesiterButtonClick(sender:UIButton)
    {
        let vc = RegesiterViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    

}
