//
//  UserCollectionViewController.swift
//  Originality
//
//  Created by suze on 16/1/29.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class UserCollectionViewController: UICollectionViewController {

    //
    var specialNameLabel:UILabel = UILabel()
    var userAvatarView:UIImageView = UIImageView()
    var userNameLabel:UILabel = UILabel()
    
    //跳转到当前界面中所传递过来的参数
    var specialId:String!
    var specialName:String!
    var username:String!
    var userId:String!
    var userAvatar:String?{
        didSet{
            BmobProFile.getFileAcessUrlWithFileName(userAvatar) { (file, error) -> Void in
                    if error != nil {
                        print("error:\(error)")
                    }
                    else {
                        let url = file.url
                        let data = NSData(contentsOfURL: NSURL(string: url)!)
                        if data != nil {
                            self.userAvatarView.image = UIImage(data: data!)
                        }
                    }
            }
    }
    }
    
    var datas:Int = PageDataCount
    var page:Int = 0
    var singleData:NSMutableArray = NSMutableArray()
    
    
    var startContentOffsetY:CGFloat!
    var willEndContentOffsetY:CGFloat!
    var endContentOffsetY:CGFloat!
    
    var _lastPosition:CGFloat = 0
    
    override  init(collectionViewLayout layout: UICollectionViewLayout){
        
        let layout = UserCollectionLayout()
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let leftBarView = UIImageView(image: UIImage(named: "white_left"))
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarView)
        
        
        
        
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FootView")
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        self.collectionView!.registerClass(UserCollectioncell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
       
            self.getPageDatas()
            
        
      
        
        self.collectionView?.backgroundColor = bgColor
        self.setupRefresh()
    }
    
    func getPageDatas()
    {
        
        
        let query:BmobQuery = BmobQuery(className:"SinglePicture")
        query.limit = PageDataCount
        query.whereKey("userId", equalTo: userId)
        query.includeKey("userId,specialId")
        
        let date:NSDate = NSDate()
        
        query.whereKey("updatedAt", lessThanOrEqualTo: date)
        //query.whereKey("userId", equalTo: userId)
        query.skip = page * PageDataCount
        query.findObjectsInBackgroundWithBlock({array,error in
            var tag:Int = 0
            for obj in array{
                if obj is BmobObject{
                    
                    
                    let spInfo:SinglePictureInfo = SinglePictureInfo()
                    if preLoading {
                        spInfo.tagId = tag
                    }
                    else {
                        spInfo.tagId = self.singleData.count
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
                        
                        spInfo.collection = obj.objectForKey("collection") as! Array<NSDictionary>
                        spInfo.collectionCount = spInfo.collection.count
                        
                    }
                    else {
                        spInfo.collectionCount = 0
                    }
                    
                    if obj.objectForKey("comment") != nil {
                        
                        spInfo.comment = obj.objectForKey("comment") as! Array<NSDictionary>
                        spInfo.commentCount = spInfo.comment.count
                        
                    }
                    else {
                        spInfo.commentCount = 0
                    }
                    
                    
                    
                    self.singleData.addObject(spInfo)
                    // print("spinfo:\(self.singleData)")
                    tag = tag + 1
                    
                }
            }
            }
        )
        
        
        self.collectionView!.reloadData()
    }
    
    
    
    func setupRefresh()
    {
        
        self.collectionView!.addFooterWithCallback({
            
            self.page = self.page + 1
            self.getPageDatas()
            
            
            let delayInSeconds:Int64 =  1000000000 * 2
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                
                var size = self.collectionView!.contentSize
                size.height = size.height + CGFloat(screenWidth / 2)  * CGFloat(PageDataCount / 2) * 1.8
                
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    var indexPaths:[NSIndexPath] = []
                    for i in self.singleData.count - PageDataCount ..< self.singleData.count {
                        let path = NSIndexPath(forItem: i, inSection: 0)
                        indexPaths.append(path)
                    }
                    
                    //                    self.collectionView!.reloadItemsAtIndexPaths(indexPaths)
                    self.collectionView!.reloadData()
                    
                })
                
                self.collectionView!.headerEndRefreshing()
                
                
                self.collectionView!.footerEndRefreshing()
                
                
            })
        })
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView!
        if kind ==  UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind( kind, withReuseIdentifier: "FootView", forIndexPath: indexPath)
            print("Footer")
            //reusableView.backgroundColor = UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)
            reusableView.backgroundColor = UIColor.redColor()
            
            let activityView  = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            activityView.center = reusableView.center
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            
            activityView.hidesWhenStopped = true
            
            activityView.startAnimating()
            reusableView.addSubview(activityView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: reusableView.frame.width, height: reusableView.frame.height))
            label.textAlignment = .Center
            label.text = "点击加载更多..."
            reusableView.addSubview(label)
            label.addSubview(activityView)
            //refreshActivity.startAnimating()
            
            
        }else if kind == UICollectionElementKindSectionHeader{
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind( kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
            
            let imageBG:UIImageView = UIImageView(frame: reusableView.frame)
            imageBG.image = UIImage(named: "img_login")
            
            reusableView.addSubview(imageBG)
            
            specialNameLabel.frame = CGRect(x: screenWidth / 2 - 50, y: 30, width: 100, height: 20)
            specialNameLabel.textAlignment = .Center
            specialNameLabel.text = specialName
            
            imageBG.addSubview(specialNameLabel)
            
            let splitView:UIImageView = UIImageView(frame: CGRect(x: specialNameLabel.frame.origin.x, y: specialNameLabel.frame.origin.y + specialNameLabel.frame.height + 15, width: specialNameLabel.frame.width, height: 1))
            splitView.backgroundColor = splitViewColor
            
            imageBG.addSubview(splitView)
            
            
            
            
            userAvatarView.frame = CGRect(x: screenWidth / 2 - 20, y: splitView.frame.origin.y + 15, width: 40, height: 40)
            userAvatarView.layer.cornerRadius = userAvatarView.frame.width / 2
            userAvatarView.clipsToBounds = true
            imageBG.addSubview(userAvatarView)

            userAvatarView.image = UIImage(named: "default_avatar")
            userAvatarView.layer.borderWidth = 1
            userAvatarView.layer.borderColor = contentColor.CGColor
            
            
            userNameLabel.frame = CGRect(x: screenWidth / 2 - 50, y: userAvatarView.frame.origin.y + 40 + 10, width: 100, height: 20)
            userNameLabel.textAlignment = .Center
            imageBG.addSubview(userNameLabel)
            
            userNameLabel.text = username

            
        }
        return reusableView
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.singleData.count == 0 {
            return self.datas
        } else {
            return self.singleData.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UserCollectioncell!
        
        if cell == nil {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? UserCollectioncell
            
            if singleData.count != 0 {
                // print("sgData:\(singleData[indexPath.row])")
                
                let sp:SinglePictureInfo = singleData[indexPath.row] as! SinglePictureInfo
                
                cell.filename = sp.url
                cell.titleLabel.text = sp.title
                cell.voteLabel.text = String(sp.upvoteCount)
                cell.commentLable.text = String(sp.commentCount)
                
                
                cell.singlePictureId = sp.objectId
                cell.userId = sp.userId
                cell.tagId = sp.tagId
                
                
                
            }
            
        }
        return cell!
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell:UserCollectioncell = collectionView.cellForItemAtIndexPath(indexPath) as! UserCollectioncell
        
        if  let tag = cell.tagId {
        
        let vc:SinglePictureDetailController = SinglePictureDetailController()
        vc.singlePictureInfo = singleData[tag] as? SinglePictureInfo
        vc.title = titleForDetail
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
    
  
    
   
    

    override func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        startContentOffsetY = scrollView.contentOffset.y
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        willEndContentOffsetY = scrollView.contentOffset.y
    }
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        endContentOffsetY = scrollView.contentOffset.x;
        if (endContentOffsetY < willEndContentOffsetY && willEndContentOffsetY < startContentOffsetY) { //画面从右往左移动,前一页
            print("前一页")
        } else if (endContentOffsetY > willEndContentOffsetY && willEndContentOffsetY > startContentOffsetY) {//画面从左往右移动,后一页
            print("后一页")
        }
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scroll")
        let currentPostion = scrollView.contentOffset.y
        if (currentPostion  > 60) {
            _lastPosition = currentPostion
            NSLog("ScrollDown now")
          // self.navigationController?.navigationBar.hidden = true
       
            
        }
        else if ( currentPostion < 64)
        {
           // self.navigationController?.navigationBar.hidden = false
            _lastPosition = currentPostion
            NSLog("ScrollUP now")
        }
    }
}
