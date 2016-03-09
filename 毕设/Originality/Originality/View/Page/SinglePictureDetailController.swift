//
//  SinglePictureDetailController.swift
//  Originality
//
//  Created by suze on 16/1/23.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SinglePictureDetailController: UIViewController,UIScrollViewDelegate ,UITextFieldDelegate{
    
    var singlePictureInfo:SinglePictureInfo?
    var heightForVote:CGFloat = 0
    
    var scrollView:UIScrollView!
    
    
    
    //
    var sendMessage:UIButton!
    var bottomView:UIView!
    //评论textview
    var commentTextView:UITextView!
    var rightCollectionButton:UIBarButtonItem!
    //var upvoteUserAvatar:UIImageView!
    
    override func viewDidAppear(animated: Bool) {
       // self.view.setNeedsDisplay()
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "share_more"), style: UIBarButtonItemStyle.Done, target: self, action: "more")
        rightCollectionButton = UIBarButtonItem(image: UIImage(named: "cl"), style: UIBarButtonItemStyle.Done, target: self, action: "collection")
    
        self.navigationItem.rightBarButtonItems = [rightButton,rightCollectionButton]
        self.navigationItem.rightBarButtonItems![0].tintColor = UIColor.grayColor()
        self.navigationItem.rightBarButtonItems![1].tintColor = UIColor.grayColor()
        
        
        //视图配置信息
        self.config()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changeStatus:",
            name: "NotificationIdentifier", object: nil)
    }
    
    func changeStatus(notification:NSNotification)
    {
        self.rightCollectionButton.tintColor = maincolor
    }
    func config(){
        self.view.backgroundColor = bgColor
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        self.scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        //添加图片内容区
        addContentView()
        
        //添加评论视图
        addCommentView()
        
        //添加点赞视图
        addUpvoteView()
        
        
        //添加被收藏到专辑视图
        addCollectionView()
        
        //添加尾部视图
        addEndView()
        
        
        //添加评论textfield以及keyboard内容
        addCommentTextfield()
        
        
    }
    
    func addCommentTextfield()
    {
        bottomView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 54, width: screenWidth, height: 64))
        bottomView.layer.borderWidth = 1
        bottomView.backgroundColor = contentColor
        bottomView.layer.borderColor = splitViewColor.CGColor
        self.view.addSubview(bottomView)
        
        
        
        
        commentTextView = UITextView(frame: CGRect(x: 10, y: 10, width: screenWidth - 70, height: 40))
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = splitViewColor.CGColor
        commentTextView.showsHorizontalScrollIndicator = false
        let subView = UIImageView(frame: CGRect(x: 10, y: 7, width: 30, height: 30))
        subView.image = UIImage(named: "write_comment")
        commentTextView.addSubview(subView)
        
        
        bottomView.addSubview(commentTextView)
        
        commentTextView.returnKeyType = UIReturnKeyType.Send
        commentTextView.enablesReturnKeyAutomatically  = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:"handleTouches:")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyBoardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        
        sendMessage = UIButton(frame: CGRect(x: commentTextView.frame.width + 10, y: 0, width: 60 , height: 50))
        
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
            let beingCommentUserId = self.singlePictureInfo?.userId
            let commentUserId = currentUser
            let user = BmobObject(withoutDatatWithClassName: "_User", objectId: commentUserId)
            
            let content = commentTextView.text
            
            var commentArray = singlePictureInfo?.comment == nil ? Array<NSDictionary>() : singlePictureInfo!.comment
            
            let obj = BmobObject(className: "comment")
            obj.setObject(content, forKey: "content")
            obj.setObject(user, forKey: "userId")
            let sp = BmobObject(withoutDatatWithClassName: "SinglePicture", objectId: self.singlePictureInfo!.objectId)
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
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let theSubviews : Array = self.view.subviews
                                
                                for subview in theSubviews {
                                    subview.removeFromSuperview()
                                }
                                self.heightForVote = 64
                                
                                self.viewDidLoad()
                            })
                            
                            
                            let vc = CommentTableViewController()
                            let nav = UINavigationController(rootViewController: vc)
                           
                            vc.commentArray = commentArray
                            vc.singlePictureUserId = self.singlePictureInfo?.userId
                            vc.commentTextView.becomeFirstResponder()
                            vc.replytoUser = self.singlePictureInfo?.userId
                            vc.singlePictureInfo = self.singlePictureInfo
                            
                            self.presentViewController(nav, animated: true, completion: nil)
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
    
    
    func addEndView()
    {
        
        let splitViewLeft:UIImageView = UIImageView(frame: CGRect(x: 10, y: heightForVote + 30, width: screenWidth/2 - 40, height: 1))
        splitViewLeft.backgroundColor = splitViewColor
        
        self.scrollView.addSubview(splitViewLeft)
        
        let splitViewRight:UIImageView = UIImageView(frame: CGRect(x: screenWidth/2 + 30, y: heightForVote + 30, width: screenWidth/2 - 40, height: 1))
        splitViewRight.backgroundColor = splitViewColor
        
        self.scrollView.addSubview(splitViewRight)
        
        
        let label = UILabel(frame: CGRect(x: splitViewLeft.frame.origin.x + splitViewLeft.frame.width, y: heightForVote + 20, width: 60, height: 20))
        label.text = "End"
        label.textAlignment = NSTextAlignment.Center
        
        self.scrollView.addSubview(label)
        
        heightForVote = label.frame.origin.y + label.frame.height
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: heightForVote + 20, width: screenWidth - 20, height: 200))
        imageView.image = UIImage(named: "bg1")
        
        self.scrollView.addSubview(imageView)
        
        heightForVote = imageView.frame.origin.y + imageView.frame.height
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: heightForVote + 64)
    }
    
    func addContentView()
    {
        let contentView = ContentView()
        
        
        let home = NSHomeDirectory() as NSString
        let path = home.stringByAppendingPathComponent("Library/Caches/DownloadFile") as NSString
        let imagePath = path.stringByAppendingPathComponent(singlePictureInfo!.url)
        let isExits:Bool = NSFileManager.defaultManager().fileExistsAtPath(imagePath)
        let image = UIImage(contentsOfFile: imagePath)
        if isExits && image != nil{
            print("sp")
            contentView.frame = CGRect(x: 0, y: self.heightForVote + 10, width: image!.size.width, height: image!.size.height + 95)
        }
        contentView.frame = CGRect(x: 10, y: self.heightForVote + 10, width: screenWidth - 20, height: 295)
        
        
        heightForVote = contentView.frame.origin.y + contentView.frame.height
        
        self.scrollView.addSubview(contentView)
        
        contentView.filename = singlePictureInfo!.url
        contentView.avatar = singlePictureInfo?.userAvator
        contentView.username.text = singlePictureInfo!.userName
        contentView.specialName.text = perDetail + singlePictureInfo!.specialName
        contentView.descript.text = singlePictureInfo!.title
        contentView.tagId = singlePictureInfo?.userId
        
        contentView.backgroundColor = contentColor
        
        if  let tag = contentView.tagId {
            
            contentView.speView.tag = singlePictureInfo!.tagId
            contentView.speView.userInteractionEnabled = true
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "userClick:")
            
            contentView.speView.addGestureRecognizer(tap)
        }
        
    }
    
    func userClick(sender:UITapGestureRecognizer){
        //  let tap:UITapGestureRecognizer = sender
        //  let tag:Int = tap.view!.tag
        let obj:SinglePictureInfo = singlePictureInfo!
        
        let vc:UserCollectionViewController = UserCollectionViewController(collectionViewLayout: UserCollectionLayout())
        vc.userId = obj.userId
        vc.username = obj.userName
        vc.userAvatar = obj.userAvator
        vc.specialName = obj.specialName
        //vc.specialId = obj.specialId
        
        self.navigationController?.pushViewController(vc, animated: true)
        print("click:user")
    }
    
    func addCollectionView()
    {
        //        [{"userId":"bPVX555A","specialId":"bPVX555A","collectionId":"7BvcFFFY"},{"userId":"7X51IIIZ","specialId":"z4TvDDDI","collectionId":"kNTBFFFR"}]
        //        ]
        
        
        let count = self.singlePictureInfo?.collectionCount
        print("count:\(count)")
        
        
        let commentTitleView = CommentView()
        commentTitleView.frame = CGRect(x: 10, y: heightForVote + 10 , width: screenWidth - 20, height: 159)
        //change heightForVote
        
        
        heightForVote = commentTitleView.frame.origin.y + commentTitleView.frame.height
        
        
        commentTitleView.backgroundColor = contentColor
        
        self.scrollView.addSubview(commentTitleView)
        
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: commentTitleView.frame.width, height: 44))
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = collectionDescript
        cell.detailTextLabel?.text = String(count)
        commentTitleView.addSubview(cell)
        
        
        let collectionScrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: commentTitleView.frame.origin.y + 50, width: 470, height: 100))
        
        self.scrollView.addSubview(collectionScrollView)
        
        //专辑图片，以及专辑名称、专辑创建者
        let imageView:UIImageView = UIImageView()
        let textLable:UILabel = UILabel()
        let userLabel = UILabel()
        
        imageView.frame = CGRectMake(20, 0, 100,
            100)
        
        collectionScrollView.addSubview(imageView)
        
        
        textLable.frame = CGRectMake(10, 70, 80,
            15)
        textLable.font = UIFont(name: "Arial", size: 12)
        imageView.addSubview(textLable)
        
        userLabel.frame = CGRectMake(10, 85, 80,
            15)
        userLabel.font = UIFont (name: "Arial", size: 11)
        imageView.addSubview(userLabel)
        
        
        userLabel.text = preString + singlePictureInfo!.userName
        textLable.text = singlePictureInfo?.specialName
        
        let specialId = singlePictureInfo?.specialId
        
        let query = BmobQuery(className: "special")
        query.getObjectInBackgroundWithId(specialId) { (obj, error) -> Void in
            
            if error != nil {
                print("get special :\(error)")
            }
            else {
                let imageName = obj.objectForKey("mainPicture") as! String
                
                BmobProFile.getFileAcessUrlWithFileName(imageName, callBack: { (file, error) -> Void in
                    if error != nil {
                        print("get mainPicture :\(error)")
                    }
                    else {
                        let url = NSURL(string: file.url)
                        let data = NSData(contentsOfURL: url!)
                        if data != nil {
                            imageView.image = UIImage(data: data!)
                        }
                    }
                })
                
            }
        }
        if singlePictureInfo?.collectionCount > 0 {
            
            let collectionArray = singlePictureInfo!.collection!
            let size = collectionArray.count
            
            let specialView:[UIImageView] = [UIImageView(),UIImageView(),UIImageView()]
            for cl in collectionArray {
                let userId = cl.objectForKey("userId") as? String
                let specialId = cl.objectForKey("specialId") as? String
                
                if specialId == self.singlePictureInfo!.objectId && userId == currentUser{
                    self.rightCollectionButton.tintColor == maincolor
                }
            }
            for i in 0 ..< size {
                
                
                
                specialView[i].frame = CGRect(x: CGFloat(i + 1) * (imageView.frame.width + 10) + 20 , y: commentTitleView.frame.origin.y + 50, width: imageView.frame.width, height: imageView.frame.height)
                
                collectionScrollView.addSubview(specialView[i])
                
                if i == 2 {
                    
                    
                    break
                }
                
            }
            
            
        }
    }
    
    func addUpvoteView()
    {
        
        
        
        if singlePictureInfo?.upvoteCount > 0 {
            
            //bPVX555A
            let voteArray = singlePictureInfo!.upvote!
            let count = voteArray.count
            print("count:\(count)")
            
            
            let commentTitleView = CommentView()
            commentTitleView.frame = CGRect(x: 10, y: heightForVote + 10 , width: screenWidth - 20, height: 44)
            //change heightForVote
            commentTitleView.titleLable.text = preUpvoteTitle + String(count)
            
            heightForVote = commentTitleView.frame.origin.y + commentTitleView.frame.height + 10
            
            commentTitleView.backgroundColor = contentColor
            
            self.scrollView.addSubview(commentTitleView)
            
            let upvoteView = CommentView()
            upvoteView.frame = CGRect(x: 10, y: commentTitleView.frame.origin.y + commentTitleView.frame.height, width: commentTitleView.frame.width, height: 60)
            upvoteView.backgroundColor = contentColor
            
            
            heightForVote = heightForVote + upvoteView.frame.height
            
            
            self.scrollView.addSubview(upvoteView)
            
            let splitView = UIImageView(frame:CGRect(x: 10, y: 0, width: upvoteView.frame.width - 20, height: 1))
            splitView.backgroundColor = splitViewColor
            
            upvoteView.addSubview(splitView)
            
            let userHeaderView:[UserHeaderView] = [UserHeaderView(),UserHeaderView(),UserHeaderView(),UserHeaderView(),UserHeaderView(),UserHeaderView()]
            for i in 0 ..< count {
                
                //点赞视图最多显示五个点赞用户头像，当点赞用户只有六个时显示全部，若多于六个则显示更多
                
                if count > 6 && i == 5{
                    
                    
                    userHeaderView[i].frame = CGRect(x: userHeaderView[i-1].frame.origin.x + userHeaderView[i-1].frame.width + distance, y: 10, width: 40, height: 40)
                    
                    
                    userHeaderView[i].layer.cornerRadius = userHeaderView[i].frame.width / 2
                    userHeaderView[i].clipsToBounds = true
                    
                    userHeaderView[i].image = UIImage(named: "more")
                    
                    upvoteView.addSubview(userHeaderView[i])
                    
                    
                    
                    break
                }
                
                
                if i == 0 {
                    
                    userHeaderView[i].frame = CGRect(x: 10, y: 10, width: 40, height: 40)
                    
                    
                }else {
                    userHeaderView[i].frame = CGRect(x: (40.0 + distance) * CGFloat(i) + 10 , y: 10, width: 40, height: 40)
                }
                
                userHeaderView[i].layer.borderWidth = 1
                userHeaderView[i].layer.borderColor = contentColor.CGColor
                userHeaderView[i].layer.cornerRadius = userHeaderView[i].frame.width / 2
                userHeaderView[i].clipsToBounds = true
                
                upvoteView.addSubview(userHeaderView[i])
                
                
                let userId:String = voteArray[i].objectForKey("userId") as! String
                
                
                let query:BmobQuery = BmobQuery(className: "_User")
                query.getObjectInBackgroundWithId(userId, block: { (user, error) -> Void in
                    if error != nil {
                        print("getUserError:\(error)")
                    }
                    else {
                        
                        let avatar:String = user.objectForKey("avatar") as! String
                        userHeaderView[i].objectId = userId
                        userHeaderView[i].avatar = avatar
                        
                    }
                })
                
                
                
                
                
                
                
                
            }
            
            
            
        }
    }
    
    func addCommentView()
    {
        
        if singlePictureInfo?.commentCount > 0 {
            let commentArray = singlePictureInfo!.comment
            let count = commentArray.count
            
            
            let commentTitleView = CommentView()
            commentTitleView.frame = CGRect(x: 10, y: heightForVote + 20 , width: screenWidth - 20, height: 44)
            //change heightForVote
            heightForVote = commentTitleView.frame.height + commentTitleView.frame.origin.y
            
            
            commentTitleView.backgroundColor = contentColor
            
            self.scrollView.addSubview(commentTitleView)
            
            commentTitleView.titleLable.text = preCommentTitle + String(count)
            
            
            
            let commentCellView:[SingleCommentView] = [SingleCommentView(),SingleCommentView(),SingleCommentView(),SingleCommentView()]
            
            for i in 0 ..< count {
                
                if i == 3 {
                    
                    commentCellView[i].frame = CGRect(x: 10, y: commentCellView[i-1].frame.origin.y + commentCellView[i-1].frame.height, width: commentCellView[i-1].frame.width, height: 50)
                    self.scrollView.addSubview(commentCellView[i])
                    commentCellView[i].backgroundColor = contentColor
                    heightForVote = commentCellView[i].frame.height + commentCellView[i].frame.origin.y
                    
                    let theSubviews : Array = commentCellView[i].subviews
                    
                    for subview in theSubviews {
                        subview.removeFromSuperview()
                    }
                    
                    let lookLabel = UILabel(frame: CGRect(x: 20, y: 5, width: commentCellView[i-1].frame.width - 20, height: commentCellView[i-1].frame.height - 10))
                    lookLabel.text = lookAll
                    lookLabel.textAlignment = .Center
                    
                    commentCellView[i].addSubview(lookLabel)
                    
                    commentCellView[i].userInteractionEnabled = true
                    commentCellView[i].tag = i
                    commentCellView[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: "reply:"))
                    
                    break
                }
                print("i:\(i)")
                //发出评论者
                let dict = commentArray[i] as! NSDictionary
                let commenter = dict.objectForKey("userId") as! String
                
                let userId = commentArray[i].objectForKey("replyto") as! String
                
                //                let commentId = commentArray[i].objectForKey("commentId") as! String
                
                let content = commentArray[i].objectForKey("content") as! String
                
                
                var str = content
                
                if singlePictureInfo!.userId != userId {
                    print("i:userid:\(i)")
                    let query:BmobQuery = BmobQuery(className: "_User")
                    query.getObjectInBackgroundWithId(userId, block: { (user, error) -> Void in
                        if error != nil {
                            print("getUserError:\(error)")
                        }
                        else {
                            let username = user.objectForKey("username") as! String
                            str = str + preReply + username
                        }
                    })
                    
                }
                
                
                let strAsNsstring = str as NSString
                let contrainsts = CGSizeMake(screenWidth - 40 , 30)
                
                
                let size =  strAsNsstring.textSizeWithFont(nomalFont, constrainedToSize: contrainsts)
                let height = size.height > 50 ? size.height + 20:50
                
                if i == 0 {
                    commentCellView[i].frame = CGRect(x: 10, y: commentTitleView.frame.origin.y + commentTitleView.frame.height, width: commentTitleView.frame.width, height: height)
                    print("0:\(commentCellView[i].frame)")
                    self.scrollView.addSubview(commentCellView[i])
                    
                    heightForVote = commentCellView[i].frame.height + commentCellView[i].frame.origin.y
                    
                    commentCellView[i].authorId = singlePictureInfo!.userId
                    
                }
                else {
                    commentCellView[i].frame = CGRect(x: 10, y: commentCellView[i-1].frame.origin.y + commentCellView[i-1].frame.height, width: commentCellView[i-1].frame.width, height: height)
                    self.scrollView.addSubview(commentCellView[i])
                    
                    heightForVote = commentCellView[i].frame.height + commentCellView[i].frame.origin.y
                    
                }
                commentCellView[i].commenter = commenter
                commentCellView[i].authorId = singlePictureInfo!.userId
                commentCellView[i].commentDetail = commentArray[i] as? NSDictionary
                
                commentCellView[i].backgroundColor = contentColor
                
                commentCellView[i].userInteractionEnabled = true
                commentCellView[i].tag = i
                commentCellView[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: "reply:"))
            }
        }
    }
    
    
    


func reply(sender:UITapGestureRecognizer){
    let tap:UITapGestureRecognizer = sender
    let tag:Int = tap.view!.tag
    let dict = (self.singlePictureInfo?.comment[tag])! as NSDictionary
    
    print("click:detail:::\(tap.view!.tag)")
    let vc:CommentTableViewController = CommentTableViewController()
    if tag == 3{
        vc.replytoUser = self.singlePictureInfo?.userId
    }
    else {
        vc.replytoUser = dict.objectForKey("userId") as? String
    }
    
    vc.commentArray = self.singlePictureInfo?.comment
    vc.singlePictureInfo = self.singlePictureInfo
    vc.singlePictureUserId = self.singlePictureInfo?.userId
    vc.commentTextView.becomeFirstResponder()
    
    let nav = UINavigationController(rootViewController: vc)
    
    self.presentViewController(nav, animated: true, completion: nil)
    
}


override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

extension SinglePictureDetailController {
    
    func more()
    {
        let shareVC = ShareViewController()
        self.presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func collection()
    {
        if rightCollectionButton.tintColor == maincolor {
            
            let tip = UIAlertView(title: nil, message: "您确定要取消收藏吗", delegate: self, cancelButtonTitle: "cancel")
            tip.show()
            return
        }
        let csVC = ChoseSpecialTableViewController()
        let vc = UINavigationController(rootViewController: csVC)
        csVC.singlePictureInfo = self.singlePictureInfo
        
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
    
    
    
}
