//
//  CreateSpecialViewController.swift
//  Originality
//
//  Created by suze on 16/2/21.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class CreateSpecialViewController: UIViewController {

    var specialnameLabel:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        config()
        // Do any additional setup after loading the view.
    }

    func config()
    {
        specialnameLabel = UITextField(frame: CGRect(x: 10, y: 84, width: screenWidth - 20, height: 44))
        
        self.view.addSubview(specialnameLabel)
        
        specialnameLabel.backgroundColor = contentColor
        specialnameLabel.placeholder = "输入专辑名称"
        
        self.view.backgroundColor = bgColor
        self.title = "评论"
        let leftButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = titleCorlor

        
        let rightButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.tintColor = maincolor
    }
    
    func done()
    {
        
        let specialName = specialnameLabel.text
        
        if specialName!.isEmpty {
            let tip = UIAlertView(title: nil, message: "请输入专辑名字", delegate: self, cancelButtonTitle: "cancel")
            tip.show()
            return
        }
        
        let user = BmobObject(withoutDatatWithClassName: "_User", objectId: currentUser)
        let category = BmobObject(withoutDatatWithClassName: "category", objectId: "bPVX555A")
        let obj = BmobObject(className: "special")
        obj.setObject(specialName, forKey: "title")
        obj.setObject(user, forKey: "userId")
        obj.setObject(category, forKey: "categoryId")
        obj.saveInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
            
            if isSuccessful {
                NSLog("comment:\(obj)")
                let dic = ["name":"hello"];
                NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: dic)
                self.navigationController?.popToRootViewControllerAnimated(true)
              
            }
            else {
                let tip = UIAlertView(title: nil, message: "创建专辑失败", delegate: self, cancelButtonTitle: "cancel")
                tip.show()
                
                print("create special:\(specialName)")
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

extension CreateSpecialViewController{
    
    func back(sender:UIBarButtonItem)
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
