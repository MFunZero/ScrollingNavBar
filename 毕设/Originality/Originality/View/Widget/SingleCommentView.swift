//
//  SingleCommentView.swift
//  Originality
//
//  Created by suze on 16/1/23.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SingleCommentView: UIView {
    
    //1:reply to current user
    //0:reply to other user
    
    var size:CGSize!
    
    var commenter:String?{
        willSet{
            self.headerView.layer.cornerRadius = self.headerView.frame.width / 2
            self.headerView.clipsToBounds=true
            self.headerView.image = UIImage(named: "default_avatar")
        }
        didSet{
            let query:BmobQuery = BmobQuery(className: "_User")
            query.getObjectInBackgroundWithId(commenter) { (bj, error) -> Void in
                if error != nil {
                    print("comment/error:\(error)")
                }
                else {
                    
                    let nameText = bj.objectForKey("username") as! String
                    self.nameLabel.text = nameText
                    self.nameLabel.textColor = userNameColor
                    
                    
                    
                    
                    let authorAvator = bj.objectForKey("avatar") as! String

                    BmobProFile.getFileAcessUrlWithFileName(authorAvator) { (file, error) -> Void in
                        if error != nil {
                            print("getUserAvatar:\(error)")
                        }
                        else {
                            let url = NSURL(string: file.url)
                            let data = NSData(contentsOfURL: url!)
                            self.headerView.image = UIImage(data: data!)
                            
                        }
                    }
                }
            }
            
        }
    }
    var authorId:String!
    
    
    
    
    
    var splitView:UIImageView = UIImageView()
    var headerView:UIImageView = UIImageView()
    var nameLabel:UILabel = UILabel()
    var commentLabel:UILabel = UILabel()
    var replyLabel:UILabel = UILabel()
    
    var beReplyUsernameLabel:UILabel = UILabel()
    var preReplyLabel:UILabel = UILabel()
    
    var commentDetail:NSDictionary?{
        willSet{
            
        }
        didSet{
            let replytoUserId = commentDetail!.objectForKey("replyto") as! String
//            let commentId = commentDetail!.objectForKey("commentId") as! String
     
            let content = commentDetail!.objectForKey("content") as! String
           
            let str = content as NSString
            let contrainsts = CGSizeMake(self.frame.width - 50, 30)
            let contentSize = str.textSizeWithFont(nomalFont, constrainedToSize: contrainsts)
           
            
            let query:BmobQuery = BmobQuery(className: "_User")
            query.getObjectInBackgroundWithId(replytoUserId) { (bj, error) -> Void in
                if error != nil {
                    print("comment/error:\(error)")
                }
                else {
                  
                    let username = bj.objectForKey("username") as! String
                    print("name:\(username)")
                    
                    
                    let nameStr = username as NSString
                    let contrainsts = CGSizeMake(self.frame.width - 50, 30)
                     let namesize =  nameStr.textSizeWithFont(UIFont(name:"Arial" , size: 12)!, constrainedToSize: contrainsts)
                    
                    
                   
                    
                    if  self.authorId == replytoUserId {
                      
                      
                        
                        self.commentLabel.text = str as String
                        self.commentLabel.frame = CGRect(x:55,y: 25, width: self.frame.width - 65, height: contentSize.height)
                        self.addSubview(self.commentLabel)
                        self.commentLabel.text = content
                    }
                    else {
                       
                       let  preReplyStr = preReply as NSString
                        let preReplyStrsize = preReplyStr.textSizeWithFont(nomalFont, constrainedToSize: contrainsts)
                        let width = preReplyStrsize.width > 40 ? preReplyStrsize.width:40
                       
                        
                        
                        self.preReplyLabel.frame = CGRect(x: 55, y: 25, width: width, height: preReplyStrsize.height)
                        self.preReplyLabel.text = preReply
                        self.addSubview(self.preReplyLabel)
                        
                        
                        
                       
                        let usernameWidth = namesize.width > 30 ? namesize.width : 30
                        
                        self.beReplyUsernameLabel.frame =
                            CGRect(x:self.preReplyLabel.frame.origin.x + self.preReplyLabel.frame.width , y: 25, width: usernameWidth, height: namesize.height)
                        self.beReplyUsernameLabel.textColor = userNameColor
                        self.beReplyUsernameLabel.text = username
                        self.addSubview(self.beReplyUsernameLabel)
                        
                        
                        let contentWidth = contentSize.width > 50 ? contentSize.width : 50
                        
                        self.commentLabel.frame = CGRect(x:5 + self.beReplyUsernameLabel.frame.origin.x + self.beReplyUsernameLabel.frame.width
                            ,y: 25, width: contentWidth, height: contentSize.height)
                        self.addSubview(self.commentLabel)
                        self.commentLabel.text = ":" + content
                    }
                    
                    
                   
                    
                }
            }
            
        }
    }
    
    
    
    //}}
    
    
    
    
    
    override func drawRect(rect: CGRect) {
        // self.backgroundColor = contentColor
        nameLabel.frame = CGRect(x: 55, y: 5, width: self.frame.width - 65, height: 20)
        self.addSubview(nameLabel)
        
        
        headerView.frame = CGRect(x: 5, y: 10, width: 40, height: 40)
        self.addSubview(headerView)
        
        
        self.headerView.layer.borderWidth = 1
        self.headerView.layer.borderColor = contentColor.CGColor
        
        splitView.frame = CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 1)
        splitView.backgroundColor = splitViewColor
        
        self.addSubview(splitView)
        
        
        self.backgroundColor = contentColor
        
        
    }
    
}
