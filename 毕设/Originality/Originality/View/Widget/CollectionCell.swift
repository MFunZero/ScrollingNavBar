//
//  CollectionCell.swift
//  Originality
//
//  Created by suze on 16/1/14.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
   
    //设置数据项，不在界面中显示，但是在跳转到下一级界面中作为数据源
    var singlePictureId:String!
    var userId:String!
    var tagId:Int!
    
    
    var topContentView:UIView = UIView()
    
    var imageView:UIImageView = UIImageView()
    var textlabel:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var detailLabel:UILabel = UILabel()
    //detailLabel上放置收藏，点赞，评论的数量
    var voteView:UIImageView = UIImageView()
    var voteLabel:UILabel = UILabel()
    
//    var collectionView:UIImageView = UIImageView()
//    var collectionLabel:UILabel = UILabel()
    
    var commentView:UIImageView = UIImageView()
    var commentLable:UILabel = UILabel()
    
    //-------分割线
    var splitView:UIImageView = UIImageView()
    
    //图片所属用户信息展示视图
    var textView:UIView = UIView()
    
   
    var headerView:UIImageView = UIImageView()
    var nameLabel:UILabel = UILabel()
    var specialName:UILabel = UILabel()
    
    var avatar:String?{
        willSet{
            self.headerView.image = UIImage(named: "default_avatar")
        }
        didSet{
            BmobProFile.getFileAcessUrlWithFileName(avatar) { (file, error) -> Void in
                if error != nil {
                    print("error:\(error)")
                }else{
                 let  url = NSURL(string: file.url)
                 let data = NSData(contentsOfURL: url!)
                    if data != nil {
                        self.headerView.image = UIImage(data: data!)
                       
                    }
            
        }
    }
 }
    }
   
    
 
    
    var filename:String? {
       
        willSet{
            
        }
        didSet{
            let home = NSHomeDirectory() as NSString
            let path = home.stringByAppendingPathComponent("Library/Caches/DownloadFile") as NSString
            let imagePath = path.stringByAppendingPathComponent(filename!)
            let isExits:Bool = NSFileManager.defaultManager().fileExistsAtPath(imagePath)
            let image = UIImage(contentsOfFile: imagePath)
            if isExits && image != nil{
                print("111111")
            self.imageView.image = image
            }
            else {
            print("222222")
            
            var url:NSURL!
            BmobProFile.getFileAcessUrlWithFileName(filename) { (file, error) -> Void in
                if error != nil {
                    print("error:\(error)")
                }else{
                    url = NSURL(string: file.url)
              
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithRequest(request,
                completionHandler: {(data, response, error) -> Void in
                    //将获取到的数据转化成图像
                    if data != nil {
                    let image = UIImage(data: data!)
                    //对UI的更新必须在主队列上完成
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        () -> Void in
                        //将已加载的图像赋予图像视图
                        self.imageView.image = image
                        //图像视图可能已经因为新图像而改变了尺寸
                        //所以需要重新调整单元格的布局
                        self.setNeedsLayout()
                    })
                           }
                        else{
                            self.imageView.image = UIImage(named:"bg6")
                        }
                    
            }) as NSURLSessionTask
            
            //使用resume方法启动任务
            dataTask.resume()
                }
                 
               
            }
            }
        }
    }

    
    override func drawRect(rect: CGRect) {
        
        topContentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 5 / 6 )

        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: topContentView.frame.height * 4 / 5 )
        
       
        
        
        textlabel.frame = CGRect(x: 10, y: topContentView.frame.height * 4 / 5 , width: self.frame.width - 20, height: topContentView.frame.height * 1 / 5 )
        
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: textlabel.frame.width , height: textlabel.frame.height * 2 / 3)
        //titleLabel.backgroundColor = UIColor.redColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.font = nomalFont
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = titleCorlor
        
        
        
        detailLabel.frame = CGRect(x: 0, y: textlabel.frame.height * 2 / 3 + 2, width: textlabel.frame.width , height: textlabel.frame.height * 1 / 3 - 5)
        
        commentView.frame = CGRect(x: 0, y: 0, width: detailLabel.frame.height, height: detailLabel.frame.height)
        commentLable.frame = CGRect(x: detailLabel.frame.height + 5, y: 0, width: detailLabel.frame.height , height: detailLabel.frame.height)
        commentView.image = UIImage(named: "message")

        commentLable.textAlignment = NSTextAlignment.Left
        commentLable.font = smallFont
        commentLable.textColor = detailCountColor
        
        voteView.frame = CGRect(x:2 * detailLabel.frame.height + 5, y: 0, width: detailLabel.frame.height, height: detailLabel.frame.height)
        voteLabel.frame = CGRect(x: 3 * (detailLabel.frame.height + 5), y: 0, width: detailLabel.frame.height , height: detailLabel.frame.height)
        voteView.image = UIImage(named: "like")
      
        voteLabel.textAlignment = NSTextAlignment.Left
        voteLabel.font = smallFont
        voteLabel.textColor = detailCountColor

//        collectionView.frame = CGRect(x:4 * detailLabel.frame.height + 5, y: 0, width: detailLabel.frame.height, height: detailLabel.frame.height)
//        collectionLabel.frame = CGRect(x: 5 * (detailLabel.frame.height + 5), y: 0, width: detailLabel.frame.height , height: detailLabel.frame.height)
//        collectionView.image = UIImage(named: "cl")
        
        
        self.detailLabel.addSubview(commentView)
        self.detailLabel.addSubview(commentLable)
        self.detailLabel.addSubview(voteView)
        self.detailLabel.addSubview(voteLabel)
//        self.detailLabel.addSubview(collectionView)
//        self.detailLabel.addSubview(collectionLabel)
        
        splitView.frame = CGRect(x: 0, y: self.frame.height * 5 / 6, width: self.frame.width, height: 1 )
        splitView.backgroundColor = UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)
        
        
        textView.frame = CGRect(x: 10, y: self.frame.height * 5 / 6 + 5, width: self.frame.width - 20, height: self.frame.height * 1 / 6 - 10  )
 
        headerView.frame = CGRect(x: 0, y: 0, width: textView.frame.height, height: textView.frame.height )
        self.headerView.layer.cornerRadius = headerView.frame.width / 2
        self.headerView.clipsToBounds=true
        
        
        specialName.frame = CGRect(x: headerView.frame.height + 5, y: 0 , width: textView.frame.width - textView.frame.height - 5, height: textView.frame.height / 2 )
        
        nameLabel.frame = CGRect(x: headerView.frame.height + 5, y: specialName.frame.height, width: textView.frame.width - textView.frame.height - 5, height: specialName.frame.height)

        
        specialName.textAlignment = NSTextAlignment.Left
        specialName.font = nomalFont
        specialName.textColor = specialNameCorlor
        
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.font = smallFont
        nameLabel.textColor = specialNameCorlor
        
        self.textView.addSubview(headerView)
        self.textView.addSubview(specialName)
        self.textView.addSubview(nameLabel)
        
        
        self.contentView.backgroundColor = contentColor
        
        self.contentView.addSubview(topContentView)
        self.topContentView.addSubview(imageView)
        self.topContentView.addSubview(textlabel)
        self.contentView.addSubview(splitView)
        self.contentView.addSubview(textView)
        
        
        self.textlabel.addSubview(titleLabel)
        self.textlabel.addSubview(detailLabel)
        
        
        
        
    }
    
}
