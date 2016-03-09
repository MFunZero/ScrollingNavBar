//
//  Collection.swift
//  Originality
//
//  Created by suze on 16/1/16.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class Collection: UICollectionViewController{

   
    
    var datas:Int = PageDataCount
    var page:Int = 0
    var singleData:NSMutableArray = NSMutableArray()
   
    
    internal override  init(collectionViewLayout layout: UICollectionViewLayout){
   
        let layout = CollectionViewLayout()
    
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
      
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FootView")
        self.collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        self.collectionView!.registerClass(CollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
       
        self.collectionView!.nowRefreshWithCallback({
           
            
            self.singleData.removeAllObjects()
            self.getPageDatas()
            
            let delayInSeconds:Int64 = 1000000000 * 2
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.collectionView!.contentSize = self.view.frame.size
                self.collectionView!.reloadData()
                
                self.collectionView!.headerEndRefreshing()
            
  
               
            })
        })
       
        self.collectionView?.backgroundColor = bgColor
        self.setupRefresh()
    }
    
    func getPageDatas()
    {
        
        
        let query:BmobQuery = BmobQuery(className:"SinglePicture")
        query.limit = PageDataCount
        
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
                    self.singleData.addObject(spInfo)
                    
                    tag = tag + 1
                    
                    
                }
            }
            }
        )
      preLoading = false
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let imageScroll:ImageScroll = ImageScroll()
            let viewScroll:ViewScroll = ViewScroll()
            
            imageScroll.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 160)
            imageScroll.imagesName = ["bg1","bg3","bg7","bg8"]
            imageScroll.time = 5
            imageScroll.addImages()
            
            
            
            viewScroll.frame = CGRect(x: 0, y: 160, width: screenWidth, height: 120)
            viewScroll.backgroundColor = UIColor.whiteColor()
            viewScroll.imagesName = ["bg1","bg3","bg7","bg8"]
            viewScroll.imageTitle = ["泛黄银杏","记忆之秋","光漏","风起时，云翩然"]
            viewScroll.time = 5
            viewScroll.addImages()
            
            reusableView.addSubview(imageScroll)
            reusableView.addSubview(viewScroll)
            
           
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
        var cell:CollectionCell!
        
        if cell == nil {
         cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CollectionCell
    
        if singleData.count != 0 {
           // print("sgData:\(singleData[indexPath.row])")
           
            let sp:SinglePictureInfo = singleData[indexPath.row] as! SinglePictureInfo
            
            cell.filename = sp.url
            cell.avatar = sp.userAvator
            cell.titleLabel.text = sp.title
            cell.voteLabel.text = String(sp.upvoteCount)
            cell.commentLable.text = String(sp.commentCount)
            cell.nameLabel.text = preString+sp.userName
            cell.specialName.text = sp.specialName
           
            
            cell.singlePictureId = sp.objectId
            cell.userId = sp.userId
            cell.tagId = sp.tagId
            
        
            
        }
     
        }
        return cell!
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell:CollectionCell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionCell
        if  let tag = cell.tagId {
        cell.topContentView.tag = tag
        cell.topContentView.userInteractionEnabled = true
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "detailClick:")
       
        cell.topContentView.addGestureRecognizer(tap)
        
        cell.textView.tag = tag
        cell.textView.userInteractionEnabled = true
        cell.textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "userClick:"))
        }
    }
    
    func detailClick(sender:UITapGestureRecognizer){
        let tap:UITapGestureRecognizer = sender 
        let tag:Int = tap.view!.tag
        let obj:SinglePictureInfo = singleData[tag] as! SinglePictureInfo
        
         print("click:detail:::\(tap.view!.tag)")
        
        
        let vc:SinglePictureDetailController = SinglePictureDetailController()
        vc.singlePictureInfo = obj
        vc.title = titleForDetail
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userClick(sender:UITapGestureRecognizer){
        let tap:UITapGestureRecognizer = sender
        let tag:Int = tap.view!.tag
        let obj:SinglePictureInfo = singleData[tag] as! SinglePictureInfo
        
        let vc:UserCollectionViewController = UserCollectionViewController(collectionViewLayout: UserCollectionLayout())
        vc.userId = obj.userId
        vc.username = obj.userName
        vc.userAvatar = obj.userAvator
        vc.specialName = obj.specialName
        vc.specialId = obj.specialId
        
        self.navigationController?.pushViewController(vc, animated: true)
        print("click:user")
    }

}
