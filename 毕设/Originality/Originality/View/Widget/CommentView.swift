//
//  CommentView.swift
//  Originality
//
//  Created by suze on 16/1/23.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class CommentView: UIView {

    //评论条数
   // var commentCount:Int!
    
    var titleLable:UILabel = UILabel()
    
    
 
    override func drawRect(rect: CGRect) {
        titleLable.frame =  CGRect(x: 10, y: 0, width: self.frame.width - 20 , height: 44)
        titleLable.textAlignment = .Left
        titleLable.textColor = titleCorlor

        self.addSubview(titleLable)
        self.backgroundColor = contentColor
        
    }

}

class UserHeaderView:UIImageView {
    var objectId:String?
    
    var avatar:String?{
        didSet {
            BmobProFile.getFileAcessUrlWithFileName(avatar) { (file, error) -> Void in
                if error != nil {
                    print("getUserAvatar:\(error)")
                }
                else {
                    let url = NSURL(string: file.url)
                    let data = NSData(contentsOfURL: url!)
                    self.image = UIImage(data: data!)
                    
                }
            }

        }
    }
  
    
}


class ContentView:UIView {
    
    //
    var tagId:String!
    
    
    var picture:UIImageView = UIImageView()
    var avatarView:UIImageView = UIImageView()
    var splitView:UIImageView = UIImageView()
    var descript:UILabel = UILabel()
    var username:UILabel = UILabel()
    var specialName:UILabel = UILabel()
    
    var speView:UIView = UIView()
    
    var avatar:String?{
        willSet{
            self.avatarView.image = UIImage(named: "default_avatar")
        }
        didSet{
            BmobProFile.getFileAcessUrlWithFileName(avatar) { (file, error) -> Void in
                if error != nil {
                    print("error:\(error)")
                }else{
                    let  url = NSURL(string: file.url)
                    let data = NSData(contentsOfURL: url!)
                    if data != nil {
                        self.avatarView.image = UIImage(data: data!)
                        
                    }
                    
                }
            }
        }

    }
    var filename:String?{
        didSet{
            let home = NSHomeDirectory() as NSString
            let path = home.stringByAppendingPathComponent("Library/Caches/DownloadFile") as NSString
            let imagePath = path.stringByAppendingPathComponent(filename!)
            let isExits:Bool = NSFileManager.defaultManager().fileExistsAtPath(imagePath)
            let image = UIImage(contentsOfFile: imagePath)
            if isExits && image != nil{
                print("111111")
                picture.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 95)
                picture.image = image
                self.addSubview(picture)
            }
            else {
                picture.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 200)
                
                
                self.addSubview(self.picture)
                
                BmobProFile.getFileAcessUrlWithFileName(filename) { (file, error) -> Void in
                    if error != nil {
                        print("error:\(error)")
                    }else{
                        let  url = NSURL(string: file.url)
                        let data = NSData(contentsOfURL: url!)
                        if data != nil {
                            self.picture.image = UIImage(data: data!)
                            
                        }
                        
                    }
                }
                
               
            }

        }
    }
    
    override func drawRect(rect: CGRect) {
        descript.frame = CGRect(x: 10, y: self.frame.height - 95, width: self.frame.width - 20, height: 44)
        
        self.addSubview(descript)
        
        
        splitView.frame = CGRect(x: 10, y: self.frame.height - 51, width: self.frame.width - 20, height: 1)
        splitView.backgroundColor = splitViewColor
        
        self.addSubview(splitView)
        
        speView.frame = CGRect(x: 0, y: splitView.frame.origin.y, width: self.frame.width, height: 51)
        
        self.addSubview(speView)
        
        
        avatarView.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.clipsToBounds = true
        
        self.speView.addSubview(avatarView)
        
        avatarView.image = UIImage(named: "default_avatar")
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = contentColor.CGColor
        
        username.frame = CGRect(x: 60, y: 5, width: self.frame.width - 65, height: 20)
        
        self.speView.addSubview(username)
        
        specialName.frame = CGRect(x: 60, y: 25, width: self.frame.width - 65, height: 20)
        
        self.speView.addSubview(specialName)
    }
    
}
