//
//  TabViewController.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

    var myTabbar :UIView?
    var slider :UIView?
    let btnBGColor:UIColor =  UIColor(red:125/255.0, green:236/255.0,blue:198/255.0,alpha: 1)
    let tabBarBGColor:UIColor =    UIColor(red:0/255.0, green:179/255.0,blue:138/255.0,alpha: 1)
    let titleColor:UIColor =  UIColor(red:52/255.0, green:156/255.0,blue:150/255.0,alpha: 1)
    
    
    let itemArray = ["首页","发现","消息","我"]
    let imageArray = ["selected1","a2","a3","a4"]
    let widthSingle = screenWidth / 4
    
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.title = "首页"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "icon_homepage_search"), style: UIBarButtonItemStyle.Done, target: self, action: "search")
        
        self.navigationItem.setRightBarButtonItem(rightButton, animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = maincolor
        //
        let leftButton = UIBarButtonItem(image: UIImage(named: "btn_add"), style: UIBarButtonItemStyle.Done, target: self, action: "addPhotos")
        
        self.navigationItem.setLeftBarButtonItem(leftButton, animated: true)
      self.navigationItem.leftBarButtonItem?.tintColor = maincolor
        
        
        setupViews()
        initViewControllers()
        //   loadData()
        // Do any additional setup after loading the view.
    }
    
    func search()
    {
        let vc = SearchViewController()
        var singleData:[SinglePictureInfo] = []
        
        let query:BmobQuery = BmobQuery(className:"SinglePicture")
        
        query.includeKey("userId,specialId")
        
        
        query.findObjectsInBackgroundWithBlock({array,error in
            var tag:Int = 0
            for obj in array{
                if obj is BmobObject{
                    
                    
                    let spInfo:SinglePictureInfo = SinglePictureInfo()
                    if preLoading {
                        spInfo.tagId = tag
                    }
                    else {
                        spInfo.tagId = singleData.count
                    }
                    spInfo.objectId = obj.objectId
                    spInfo.title = obj.objectForKey("title") as! String
                    
                    spInfo.url = obj.objectForKey("url") as! String
                    
                    BmobProFile.downloadFileWithFilename(spInfo.url, block: { (successful, error, str) -> Void in
                        if successful {
                            
                            print("downloadFileWithFilename GET successful to:\(str):home:\(NSHomeDirectory())")
                        }
                        else if error != nil {
                            print("error:\(error)")
                        }
                        }, progress: { (pro) -> Void in
                            print("progress:\(pro)")
                    })
                    
                    //根据所关联的用户信息获取用户头像
                    let user:BmobUser = obj.objectForKey("userId") as! BmobUser
                    spInfo.userId = user.objectId
                    spInfo.userName = user.username
                    spInfo.userAvator = user.objectForKey("avatar") as! String
                    //获取专辑信息
                    let special:BmobObject = obj.objectForKey("specialId") as! BmobObject
                    spInfo.specialId = special.objectId
                    
                    spInfo.specialName = special.objectForKey("title") as! String
                    
                    //根据评论、点赞、收藏情况获取计数情况以及具体内容
                    
                    if obj.objectForKey("upvote") != nil {
                        
                        spInfo.upvote = obj.objectForKey("upvote") as! Array
                        spInfo.upvoteCount = spInfo.upvote.count
                        
                    }
                    else {
                        spInfo.upvoteCount = 0
                    }
                    
                    if obj.objectForKey("collection") != nil {
                        
                        spInfo.collection = obj.objectForKey("collection") as! Array
                        spInfo.collectionCount = spInfo.collection.count
                        
                    }
                    else {
                        spInfo.collectionCount = 0
                    }
                    
                    if obj.objectForKey("comment") != nil {
                        
                        spInfo.comment = obj.objectForKey("comment") as! Array
                        spInfo.commentCount = spInfo.comment.count
                        
                    }
                    else {
                        spInfo.commentCount = 0
                    }
                    
                    
                    //                    if tag >= 60 {
                    //                    print("spinfoCo:\(spInfo):tag:\(tag)")
                    //                    }
                    singleData.append(spInfo)
                    //singleData.addObject(spInfo)
                    
                    tag = tag + 1
                    
                    
                }
            }
            vc.ctrls = singleData
            self.navigationController?.pushViewController(vc, animated: true)
            }
        )
        
    

    }
    //addPhotos
    func addPhotos()
    {
        let vc = AddPhotosViewController()
        self.presentViewController(vc, animated: true, completion: nil)
       
    }
    
    func setupViews()
    {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        self.tabBar.hidden = true
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        self.myTabbar = UIView(frame: CGRectMake(0,height-44,width,44))
        self.myTabbar!.backgroundColor = tabBarBGColor
        self.slider = UIView(frame:CGRectMake(0,0,widthSingle,44))
        self.slider!.backgroundColor = UIColor.whiteColor()//btnBGColor
        self.myTabbar!.addSubview(self.slider!)
        
        self.view.addSubview(self.myTabbar!)
        
        let count = self.itemArray.count
        
        for var index = 0; index < count; index++
        {
              let btnWidth = CGFloat(index) * widthSingle
            
            let imageView = UIImageView(frame: CGRectMake(btnWidth,0,widthSingle,44))
            
            imageView.image = UIImage(named:imageArray[index])
            imageView.tag = index
            
            let button  = UIButton(type: UIButtonType.Custom)
            button.frame = CGRectMake(btnWidth, 0,widthSingle,44)
            button.tag = index+100
            let title = self.itemArray[index]
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(tabBarBGColor, forState: UIControlState.Selected)
            
            button.addTarget(self, action: "tabBarButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            self.myTabbar?.addSubview(button)
            if index == 0
            {
                button.selected = true
            }
        }
    }
   
    func initViewControllers()
    {
        let vc1 = Collection(collectionViewLayout: CollectionViewLayout())
       // vc1.jokeType = .NewestJoke
        let vc2 = SecondViewController()
       // vc2.jokeType = .HotJoke
        let vc3 = ThirdTableViewController()
      //  vc3.jokeType = .ImageTruth
        let vc4 = FourthTableViewController()
        self.viewControllers = [vc1,vc2,vc3,vc4]
    }
    
    
    func tabBarButtonClicked(sender:UIButton)
    {
        let index = sender.tag
        
        if (index == 102 || index == 103) && currentUser.isEmpty{
            let vc = EnterPageViewController()
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
        for var i = 0;i<self.itemArray.count;i++
        {
            let button = self.view.viewWithTag(i+100) as! UIButton
            if button.tag == index
            {
                button.selected = true
                self.selectedIndex = index-100
                
                
               
            }
            else
            {
                button.selected = false
                
            }
        }
        UIView.animateWithDuration( 0.3,
            animations:{
                
                self.slider!.frame = CGRectMake(CGFloat(index-100) * self.widthSingle,0,self.widthSingle,44)
                
        })
        
        self.title = itemArray[index-100] as String
    }
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
