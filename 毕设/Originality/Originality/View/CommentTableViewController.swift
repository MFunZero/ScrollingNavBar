//
//  CommentTableViewController.swift
//  Originality
//
//  Created by suze on 16/2/21.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {

    var commentArray:Array<NSDictionary>!
    var singlePictureUserId:String!
    var singlePictureInfo:SinglePictureInfo!
    
    var sendMessage:UIButton = UIButton()
    var bottomView:UIView = UIView()
    //评论textview
    var commentTextView:UITextView = UITextView()
    var replytoLabel:UILabel = UILabel()
    var replytoUser:String?{
        didSet {
            let userQuery = BmobQuery(className: "_User")
            
            userQuery.getObjectInBackgroundWithId(replytoUser) { (obj, error) -> Void in
                let username = obj.objectForKey("username") as? String
                
                self.replytoLabel.text = preReply + " " + username!
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = bgColor
        self.title = "评论"
        let leftButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.leftBarButtonItem?.tintColor = titleCorlor
        
        self.addCommentTextfield()
        
    
        self.tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    func addCommentTextfield()
    {
        bottomView.frame = CGRect(x: 0, y: screenHeight - 124, width: screenWidth, height: 64)
        bottomView.layer.borderWidth = 1
        bottomView.backgroundColor = contentColor
        bottomView.layer.borderColor = splitViewColor.CGColor
        
        self.view.addSubview(bottomView)
        
        
        commentTextView.frame =  CGRect(x: 10, y: 10, width: screenWidth - 70, height: 40)
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = splitViewColor.CGColor
        commentTextView.showsHorizontalScrollIndicator = false
         replytoLabel.frame = CGRect(x: 10, y: 5, width: screenWidth / 2, height: 30)
        commentTextView.addSubview(replytoLabel)
        
        replytoLabel.textColor = bgColor
        
        bottomView.addSubview(commentTextView)
        
     
        commentTextView.font = bigFont
        
        commentTextView.returnKeyType = UIReturnKeyType.Next
        commentTextView.enablesReturnKeyAutomatically  = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        
        sendMessage.frame = CGRect(x: commentTextView.frame.width + 10, y: 0, width: 60 , height: 50)
        
        sendMessage.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
        
        bottomView.addSubview(sendMessage)
        sendMessage.setTitleColor(maincolor, forState: .Normal)
        sendMessage.setTitle("发送", forState:.Normal)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func click(sender:UIButton)
    {
        print("getMessage:\(commentTextView.text)")
        
        
        
        if commentTextView.text.isEmpty {
            let alertView:UIAlertView = UIAlertView(title: "输入内容为空，请重新输入", message: nil, delegate: self, cancelButtonTitle: "取消")
            alertView.show()
            self.commentTextView.becomeFirstResponder()
        }
        else {
            
            let commentUser = BmobUser.getCurrentUser()
            let beingCommentUserId = self.replytoUser
           
            let commentUserId = currentUser
            
            let user = BmobObject(withoutDatatWithClassName: "_User", objectId: commentUserId)
            
            let content = commentTextView.text
            
            var commentArray = self.commentArray
            
            let obj = BmobObject(className: "comment")
            obj.setObject(content, forKey: "content")
            obj.setObject(user, forKey: "userId")
            let sp = BmobObject(withoutDatatWithClassName: "SinglePicture", objectId: self.singlePictureInfo.objectId)
            obj.setObject(sp, forKey: "sgId")
            
            obj.saveInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
                
                if isSuccessful {
                    NSLog("comment:\(obj)")
                    let commentId = obj.objectId
                    
                    
                    //[{"userId":"bPVX555A","commentId":"GTrU999C","replyto":"xFWO111A","content":"超赞，心水!"},{"userId":"xFWO111A","commentId":"DFktIIIS","replyto":"VL4u777D","content":"赞一个"}]
                    let dict = NSDictionary(objects: [commentUserId,commentId,beingCommentUserId!,content], forKeys: ["userId","commentId","replyto","content"])
                    //let array = Array(object: dict)
                    
                    commentArray.insert(dict, atIndex: commentArray.count)
                    
                    let comentObject = BmobObject(withoutDatatWithClassName: "SinglePicture", objectId: self.singlePictureInfo?.objectId)
                    comentObject.setObject(commentArray, forKey: "comment")
                    comentObject.updateInBackgroundWithResultBlock({ (isSuccessful, error) -> Void in
                        if isSuccessful {
                            print("评论成功")
                            
                            self.singlePictureInfo?.comment = commentArray
                            self.singlePictureInfo?.commentCount = commentArray.count
                            self.replytoUser = self.singlePictureInfo.userId
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                               self.tableView.reloadData()
                            })
                            
                        }
                        else {
                            print("error:\(error)")
                        }
                    })
                }
                else {
                    print("CommentSaveerror:\(error)")
                }
                
            })
            
        }
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        
        
        let userInfo  = note.userInfo as! NSDictionary
        
        
        print("will:\(userInfo)")
        var  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        
        //var keyBaoardViewFrame = keyBoardView.frame
        let deltaY:CGFloat = 254
        
        let animations:(() -> Void) = {
            
            self.bottomView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        
        let userInfo  = note.userInfo as! NSDictionary
        print("hide:\(commentTextView.text)")
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            
            self.bottomView.transform = CGAffineTransformIdentity
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
        }else{
            
            animations()
        }
        
        
        
        
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
            commentTextView.resignFirstResponder()
            
            
        }
        
        
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.commentArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as? CustomTableViewCell
        
        let dict = self.commentArray[indexPath.row]
        
        
       // cell?.detailLabel.text =

        let userId = dict.objectForKey("userId") as! String
        let query = BmobQuery(className: "_User")
        query.getObjectInBackgroundWithId(userId) { (obj, error) -> Void in
            if error != nil {
                NSLog("%@", error)
                
            }
            else {
                let filename = obj.objectForKey("avatar") as! String
                cell?.fileName = filename
                cell?.titleLabel.text = obj.objectForKey("username") as? String
                
            }
        }
        
        let CommentId = dict.objectForKey("commentId") as? String
        let commentQuery = BmobQuery(className: "comment")
        commentQuery.getObjectInBackgroundWithId(CommentId) { (comment, error) -> Void in
            if error != nil {
                NSLog("%@", error)
                
            }
            else {
                let replyto = self.replytoUser
                let content = dict.objectForKey("content") as? String
                
                if replyto == self.singlePictureUserId {
                    cell?.detailLabel.text = content
                    
                    format.dateFormat = "MM/dd hh:mm"
                    let dateString = format.stringFromDate(comment.createdAt)
                    cell?.timeLabel.text = dateString
                }
                else {
                    let query = BmobQuery(className: "_User")
                    query.getObjectInBackgroundWithId(replyto) { (replyto, error) -> Void in
                        if error != nil {
                            NSLog("%@", error)
                            
                        }
                        else {
                            let replyto = replyto.objectForKey("username") as! String
                            cell?.detailLabel.text = preReply + replyto + " : " + content!
                            
                        }
                    }
                }
                
            }
        }

        
        
        return cell!
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = commentArray[indexPath.row] as? NSDictionary
        
        self.replytoUser = dict?.objectForKey("userId") as? String
        
        self.commentTextView.becomeFirstResponder()
        
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentTableViewController{
    
    func back(sender:UIBarButtonItem)
    {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
