//
//  FirstViewController.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    var collectionView:UICollectionView!
   
    var imageScroll:ImageScroll = ImageScroll()
    var viewScroll:ViewScroll = ViewScroll()
    
    
   
    //课程名称和图片，每一门课程用字典来表示
    let courses = [
    ["name":"SwiftOCSwiftOCSwiftOCSwiftOCSwift","pic":"first"],
    ["name":"OCSwiftOCSwiftOCSwiftOCSwiftOCSwift","pic":"first"],
    ["name":"JavaSwiftSwift","pic":"first"],
    ["name":"PHPSwiftSwift","pic":"first"],
    ["name":"JSSwiftSwift","pic":"first"],
    ["name":"HTMLSwiftSwiftSwiftSwift","pic":"first"],
    ["name":"RubySwiftSwiftSwiftSwift","pic":"first"],
    ["name":"HTML","pic":"first"],
    ["name":"Ruby","pic":"first"],
    ["name":"OC","pic":"first"],
    ["name":"Java","pic":"first"],
    ["name":"PHP","pic":"first"],
    ["name":"JS","pic":"first"],
    ["name":"HTML","pic":"first"],
    ["name":"Ruby","pic":"first"],
    ["name":"HTML","pic":"first"],
    ["name":"Ruby","pic":"first"]
    ]
    let count = 48
    let countInLine = 2
    var refreshActivity:UIActivityIndicatorView!
    
     var datas:Int = 10
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
 
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        
         config()
        
        weak var weakSelf = self as FirstViewController
        
        // 加载更多
        collectionView.toLoadMoreAction { () -> () in
            weakSelf?.delay(0.5, closure: { () -> () in})
            weakSelf?.delay(0.5, closure: { () -> () in
                print("toLoadMoreAction success")
                if weakSelf?.datas < 40 {
                    weakSelf?.datas += (Int)(arc4random_uniform(10)) + 1
                   
                    weakSelf?.collectionView.reloadData()
                }else {
                    // 数据加载完毕
                    weakSelf?.collectionView.endLoadMoreData()
                }
                weakSelf?.collectionView.doneRefresh()
            })
        }
        
        // 立马进去就刷新
        collectionView.nowRefresh({ () -> Void in
            weakSelf?.delay(5.0, closure: { () -> () in})
            weakSelf?.delay(5.0, closure: { () -> () in
                print("nowRefresh success")
                weakSelf?.datas += (Int)(arc4random_uniform(10)) + 1
                weakSelf?.collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (weakSelf?.collectionView.frame.height)!)
                weakSelf?.collectionView.reloadData()
                weakSelf?.collectionView.doneRefresh()
            })
        })
       
        // Do any additional setup after loading the view.
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
       func config()
    {
       self.view.backgroundColor =  UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)
        

        
        
        let layout = CollectionViewLayout()
        layout.countInLine = countInLine
        
        let height = ((screenWidth) / CGFloat(countInLine) ) * 1.5 * CGFloat(count / countInLine) + 320
       
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y:  64, width: screenWidth , height: height), collectionViewLayout: layout)
        
        // 注册CollectionViewCell
        self.collectionView.registerClass(CollectionCell.self,
            forCellWithReuseIdentifier: "ViewCell")
       
        //let nib = UINib(nibName: "nn", bundle: nil)
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FootView")
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        //默认背景是黑色和label一致
        self.collectionView.backgroundColor = UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
      
        
       // self.collectionView.alwaysBounceVertical = false
        
 
        
        
       
        
        self.view.addSubview(collectionView)
        
        
        
    }
    
       func operation(data: NSMutableData) {
        print("operation:\(data.length)")
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       // print("scrollViewDidScroll")
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
            return self.count
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView!
        if kind ==  UICollectionElementKindSectionFooter {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind( kind, withReuseIdentifier: "FootView", forIndexPath: indexPath)
            
             reusableView.backgroundColor = UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)
            
            
            let activityView  = UIActivityIndicatorView(frame:CGRectMake(reusableView.frame.size.width/2 - 30, 10, 100, 100))
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
           
            activityView.hidesWhenStopped = true
   
            reusableView.addSubview(activityView)
            collectionView.addSubview(activityView)
            self.refreshActivity = activityView
            refreshActivity.color = UIColor.blackColor()
            
        
            let label = UILabel(frame: reusableView.frame)
            label.text = "loading..."
            reusableView.addSubview(label)
            //refreshActivity.startAnimating()
            
           
        }else if kind == UICollectionElementKindSectionHeader{
             reusableView = collectionView.dequeueReusableSupplementaryViewOfKind( kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
            
            
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
    // 获取单元格
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
              collectionView.contentSize = CGSize(width: 0, height: 0)
            
            
            // storyboard里设计的单元格
            let identify:String = "ViewCell"
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! CollectionCell
//            cell.imageView.image = UIImage(data: dataArray[indexPath.row] as! NSData)
            let str = courses[1]["name"]! as NSString
            let contrainsts = CGSizeMake(cell.frame.width - 5, 30)
            
            let size =  str.textSizeWithFont(UIFont(name:"Arial" , size: 14)!, constrainedToSize: contrainsts)
            
            cell.label.text = str as String
            cell.label.frame = CGRect(x:0,y: cell.frame.height * 4 / 5, width: size.width, height: size.height)
            //cell.imageView.image = UIImage(data: dataArray[indexPath.row] as! NSData)
            cell.imageView.alpha = 0.2
            cell.imageView.transform = CGAffineTransformMakeScale(0.2, 0.2)
            cell.label.alpha = 0.2
            cell.label.transform = CGAffineTransformMakeScale(0.2, 0.2)
            cell.center.x = -cell.frame.width / 2
            //cell.center.y = cell.frame.height + self.view.frame.height
            UIView.animateWithDuration(1) { () -> Void in
                cell.imageView.alpha = 1
                cell.imageView.transform = CGAffineTransformMakeScale(1, 1)
                cell.label.alpha = 1
                cell.label.transform = CGAffineTransformMakeScale(1, 1)
                cell.center.x += cell.frame.width + CGFloat(CGFloat(indexPath.row % (self.countInLine)) * self.view.frame.width / CGFloat(self.countInLine)) + 5
                //cell.center.y -= cell.frame.height * CGFloat(indexPath.row / (self.count / 2)) + self.view.frame.height - cell.frame.height
                //print("indexPath.row:\(indexPath.row)")
            }
            return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let second = SecondViewController()
        self.presentViewController(second, animated: true, completion: nil)
    }
    
    
}
extension NSString {
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as? [String : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
}
}