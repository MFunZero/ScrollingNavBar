//
//  EditTitleViewController.swift
//  Originality
//
//  Created by suze on 16/2/18.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class EditTitleViewController: BaseViewController {

    var photoView:UIImageView = UIImageView()
    var textView:UITextView = UITextView()
    
    //
    var specialId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "发布"
        setNavigationItem(cancel, selector: "doLeft", isRight: false)
        
  
        setNavigationItem("下一步", selector: "doRight", isRight: true)

        configView()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changeStatus:",
            name: "Notification", object: nil)
    }
    
    func changeStatus(notification:NSNotification)
    {
       let dict = notification.userInfo! as NSDictionary
        self.specialId = dict.objectForKey("specialId") as? String
        
        setNavigationItem("完成", selector: "done", isRight: true)
    }
    
    func done()
    {
        let data = UIImagePNGRepresentation(photoView.image!)!
        let datas:[NSData]! = [data]
       BmobProFile.uploadFilesWithDatas(datas, resultBlock: { (filenameArray, urlArray, bmobFileArray, error) -> Void in
        if error != nil {
            NSLog("errorPhoto%@",error);
        } else {
            //路径数组和url数组（url数组里面的元素为NSString）
            NSLog("fileArray %@ urlArray %@",filenameArray,urlArray);
            for  bmobFile in bmobFileArray  {
                NSLog("%@", bmobFile.url)
                
            }
        }
        }) { (index, progress) -> Void in
                //index表示正在上传的文件其路径在数组当中的索引，progress表示该文件的上传进度
                NSLog("index %lu progress %f",index,progress);
        }
    }

    func configView()
    {
        photoView.frame = CGRect(x: 25, y: 89, width: 40, height: 40)
        
        self.view.addSubview(photoView)
        
        textView.frame = CGRect(x: 90, y: 89, width: screenWidth - 115, height: screenHeight / 2 - 89)
        
        self.view.addSubview(textView)
        
        textView.becomeFirstResponder()
    }
    
    
    
     func doLeft() {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


    override func doRight()
    {
        let csVC = ChoseSpecialTableViewController()
        let vc = UINavigationController(rootViewController: csVC)
        
        var singlePicture=SinglePictureInfo()
        singlePicture.title = self.textView.text
        
        //csVC.singlePictureInfo = self.singlePictureInfo
        
        let query = BmobQuery(className: "special")
        
        var specials:[SpecialInfo] = []
        
        query.includeKey("userId,categoryId")
        
        query.whereKey("userId", equalTo: currentUser)
        query.findObjectsInBackgroundWithBlock { (objs, error) -> Void in
            if error != nil {
                NSLog("specialQuery:\(error)")
            }
            else {
                for obj in objs {
                    let special = SpecialInfo()
                    special.objectId = obj.objectId
                    special.title = obj.objectForKey("title") as? String
                    
                    if let picture = obj.objectForKey("mainPicture") as? String {
                        special.pictureName = picture as? String
                    }
                    else {
                        special.pictureName = defaultImage
                    }
                    
                    if let account = obj.objectForKey("count") {
                        special.count = account as? Int
                    }
                    else {
                        special.count = 0
                    }
                    
                    let user:BmobUser = obj.objectForKey("userId") as! BmobUser
                    special.userId = user.objectId
                    
                    //获取专辑信息
                    let category:BmobObject = obj.objectForKey("categoryId") as! BmobObject
                    special.categoryId = category.objectId
                    
                    specials.append(special)
                }
                
                csVC.specials = specials
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        

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
