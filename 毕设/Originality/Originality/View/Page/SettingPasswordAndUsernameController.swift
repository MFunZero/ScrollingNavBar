//
//  SettingPasswordAndUsernameController.swift
//  Originality
//
//  Created by suze on 16/2/6.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SettingPasswordAndUsernameController: UIViewController {
    
    var contentView:UIView!
    var usernameTextfield:UITextField!
    var passwordTextfield:UITextField!
    var loginButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        addContentView()
        
        self.title = "账号设置"
        let leftButton = UIBarButtonItem(image: UIImage(named: "grey_left"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = titleCorlor
        
        let rightButton = UIBarButtonItem(title: "完成", style: .Done, target: self, action: "back:")
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = titleCorlor

    
    }

    func addContentView()
    {
        contentView = UIView(frame: CGRect(x: 20, y: 74, width: screenWidth - 40, height: 88))
        self.view.addSubview(contentView)
        
        contentView.backgroundColor = contentColor
        
        usernameTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: 44))
        
        self.contentView.addSubview(usernameTextfield)
        
        usernameTextfield.clearButtonMode = .WhileEditing
        usernameTextfield.placeholder = "昵称"
        
        
        
        
        let splitView = UIView(frame: CGRect(x: 0, y: usernameTextfield.frame.origin.y + usernameTextfield.frame.height - 1, width: usernameTextfield.frame.width, height: 1))
        
        splitView.backgroundColor = splitViewColor
        self.contentView.addSubview(splitView)
        
        passwordTextfield = UITextField(frame: CGRect(x: 0, y: usernameTextfield.frame.origin.y + usernameTextfield.frame.height, width: usernameTextfield.frame.width, height: usernameTextfield.frame.height))
        
        self.contentView.addSubview(passwordTextfield)
        
        passwordTextfield.clearButtonMode = .WhileEditing
        passwordTextfield.secureTextEntry = true
        passwordTextfield.placeholder = "密码"
        
        
        let bottomView = UIView(frame: CGRect(x: 0, y: passwordTextfield.frame.origin.y + passwordTextfield.frame.height - 1, width: passwordTextfield.frame.width, height: 1))
        
        bottomView.backgroundColor = splitViewColor
        self.contentView.addSubview(bottomView)
        
    }
    func doneClick(sender:UIBarButtonItem)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func back(sender:UIBarButtonItem)
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
