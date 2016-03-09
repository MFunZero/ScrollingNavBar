//
//  RegesiterViewController.swift
//  Originality
//
//  Created by suze on 16/2/3.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class RegesiterViewController: UIViewController ,UITextFieldDelegate {
    
    var contentView:UIView!
    var phoneNumberTextfield:UITextField!
    var passwordTextfield:UITextField!
    var loginButton:UIButton!
    var validButton:UIButton!
    
    var secondsCountDown:Int!
    var countDownTimer:NSTimer!
    
    override func viewDidAppear(animated: Bool) {
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("loginUserName") != nil {
            
            self.phoneNumberTextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("loginUserName") as? String
            
            self.passwordTextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("loginPassword") as? String
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = bgColor
        
        
        self.title = "注册"
        let leftButton = UIBarButtonItem(image: UIImage(named: "grey_left"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = titleCorlor
        
        let rightButton = UIBarButtonItem(title: "登陆", style: .Done, target: self, action: "loginButtonClick:")
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = titleCorlor
        
        
        
        
        
        configView()
        
        phoneNumberTextfield.delegate = self
        // passwordTextfield.delegate = self
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func loginButtonClick(sender:UIButton)
    {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func back(sender:UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didChange(sender:NSNotification)
    {
        
        if phoneNumberTextfield.text!.isEmpty {
            self.loginButton.enabled = false
            self.loginButton.backgroundColor = UIColor.grayColor()
        }
        else {
            self.loginButton.backgroundColor = maincolor
            self.loginButton.enabled = true
        }
        
        
    }
    
    
    func configView()
    {
        contentView = UIView(frame: CGRect(x: 20, y: 74, width: screenWidth - 40, height: 88))
        self.view.addSubview(contentView)
        
        contentView.backgroundColor = contentColor
        
        phoneNumberTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: screenWidth - 40, height: 44))
        
        self.contentView.addSubview(phoneNumberTextfield)
        
        phoneNumberTextfield.clearButtonMode = .WhileEditing
        phoneNumberTextfield.placeholder = "手机号码"
        
        
        
        
        let splitView = UIView(frame: CGRect(x: 0, y: phoneNumberTextfield.frame.origin.y + phoneNumberTextfield.frame.height - 1, width: phoneNumberTextfield.frame.width, height: 1))
        
        splitView.backgroundColor = splitViewColor
        self.contentView.addSubview(splitView)
        
        passwordTextfield = UITextField(frame: CGRect(x: 0, y: phoneNumberTextfield.frame.origin.y + phoneNumberTextfield.frame.height, width: phoneNumberTextfield.frame.width - 100, height: phoneNumberTextfield.frame.height))
        
        self.contentView.addSubview(passwordTextfield)
        
        passwordTextfield.clearButtonMode = .WhileEditing
        passwordTextfield.secureTextEntry = true
        passwordTextfield.placeholder = "验证码"
        
        validButton = UIButton(frame: CGRect(x: phoneNumberTextfield.frame.width - 100, y: passwordTextfield.frame.origin.y, width: 100, height: passwordTextfield.frame.height))
        
        self.contentView.addSubview(validButton)
        
        validButton.setTitle("获取验证码", forState: .Normal)
        validButton.setTitleColor(titleCorlor, forState: .Normal)
        validButton.addTarget(self, action: "requestSMSCode", forControlEvents: .TouchUpInside)
        
        let leftBorderView = UIImageView(frame: CGRect(x: validButton.frame.origin.x, y: validButton.frame.origin.y + 5, width: 1, height: validButton.frame.height - 10))
        
        self.contentView.addSubview(leftBorderView)
        
        leftBorderView.backgroundColor = splitViewColor
        
        
        let bottomView = UIView(frame: CGRect(x: 0, y: passwordTextfield.frame.origin.y + passwordTextfield.frame.height - 1, width: phoneNumberTextfield.frame.width, height: 1))
        
        bottomView.backgroundColor = splitViewColor
        self.contentView.addSubview(bottomView)
        
        
        
        loginButton = UIButton(frame: CGRect(x: 20, y: self.self.contentView.frame.origin.y + self.contentView.frame.height + 25, width: bottomView.frame.width, height: 44))
        
        self.view.addSubview(loginButton)
        
        
        loginButton.backgroundColor = UIColor.grayColor()
        loginButton.setTitle("注册", forState: .Normal)
        loginButton.setTitleColor(contentColor, forState: .Disabled)
        loginButton.layer.cornerRadius = 4.0
        
        self.loginButton.addTarget(self, action: "regesiter", forControlEvents: .TouchUpInside)
        self.loginButton.enabled = false
        
        
    }
    
    func requestSMSCode()
    {
        let phoneNumber = phoneNumberTextfield.text 
        
        BmobSMS.requestSMSCodeInBackgroundWithPhoneNumber(phoneNumber, andTemplate: "test") { (number, error) -> Void in
            if error != nil {
                NSLog("%@", error)
                
                let tip = UIAlertView(title: nil, message: "请输入正确的手机号", delegate: self, cancelButtonTitle: "确定")
                
                tip.show()
            }
            else {
                
                NSLog("sms ID: %d",number )
                
                self.setRequestSMSCodeBtnCountDown()
            }
        }
       

    }
    
    func setRequestSMSCodeBtnCountDown()
    {
        self.validButton.enabled = true
        
        self.secondsCountDown = 60
        
         countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDownTimeWithSeconds:", userInfo: nil, repeats: true)
        countDownTimer.fire()

        }
        
    func countDownTimeWithSeconds(timerInfo:NSTimer){
            if (secondsCountDown == 0) {
                self.validButton.enabled = true
                self.validButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                self.validButton.setTitle("获取验证码", forState: .Normal)
                
                countDownTimer.invalidate()
                
            } else {
                self.validButton.setTitle(String(secondsCountDown), forState: UIControlState.Normal)
                self.secondsCountDown = self.secondsCountDown - 1
        }
        
        }
    
    func regesiter()
    {
//        let phoneNumber = phoneNumberTextfield.text
//        let smsCode = passwordTextfield.text
//        
//        print("name:\(phoneNumber);pwd:\(smsCode)")
//        
//        if smsCode == "" {
//            
//            passwordTextfield.clearButtonMode = .Always
//            passwordTextfield.becomeFirstResponder()
//            
//            
//            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//                self.passwordTextfield.center.x -= 15
//                }, completion: nil)
//            UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//                self.passwordTextfield.center.x += 15
//                }, completion: nil)
//            UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//                self.passwordTextfield.center.x += 15
//                }, completion: nil)
//            UIView.animateWithDuration(0.3, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//                self.passwordTextfield.center.x -= 15
//                }, completion: nil)
//            
//            
//            
//        }
//        else {
//            
//            BmobSMS.verifySMSCodeInBackgroundWithPhoneNumber(phoneNumber, andSMSCode: smsCode, resultBlock: { (isSuccessful, error) -> Void in
//                if isSuccessful {
//                    let currentUser = BmobUser.getCurrentUser()
//                    currentUser.mobilePhoneNumber = phoneNumber
//                    currentUser.setObject(NSNumber(bool: true), forKey: "mobilePhoneNumberVerified")
//                    currentUser.updateInBackgroundWithResultBlock({ (isSuccess, error) -> Void in
//                        if error != nil {
//                            NSLog("%@", error)
//                        }
//                        else {
//                            
//                            let tip = UIAlertView(title: nil, message: "手机验证成功", delegate: self, cancelButtonTitle: "确定")
//                            tip.show()
//                        }
//                    })
//                    
//                }
//                else {
//                    NSLog("%@", error)
//                    
//                    let tip = UIAlertView(title: nil, message: "验证码有误", delegate: self, cancelButtonTitle: "确定")
//                    tip.show()
//                }
//            })
        
//        }
        
        
        self.navigationController?.pushViewController(SettingPasswordAndUsernameController(), animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        phoneNumberTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
