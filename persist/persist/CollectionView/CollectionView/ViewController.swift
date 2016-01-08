//
//  ViewController.swift
//  CollectionView
//
//  Created by suze on 15/12/5.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    var collectionView:UICollectionView!
    //课程名称和图片，每一门课程用字典来表示
    let courses = [
        ["name":"Swift","pic":"first"],
        ["name":"OCSwift","pic":"first"],
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
    let count = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout = CustomLayout()
        //let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width / CGFloat(count / 2) * 2 + 100 ), collectionViewLayout: layout)
        
        // 注册CollectionViewCell
        self.collectionView.registerClass(CollectionCell.self,
            forCellWithReuseIdentifier: "ViewCell")
        //let nib = UINib(nibName: "nn", bundle: nil)
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
      
                //默认背景是黑色和label一致
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
   
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableview:UICollectionReusableView!
        print("reusableview")
        if (kind == UICollectionElementKindSectionHeader) {
            
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(kind
                , withReuseIdentifier:"HeaderView" , forIndexPath: indexPath)
            print("reusableview:\(reusableview.frame)")
            print("\(UIScreen.mainScreen().bounds)")
            let  title:UITableViewCell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
            print("\(title.bounds)")
            title.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            title.textLabel?.text = "推荐歌单"
            //title.backgroundColor = UIColor.redColor()
             reusableview.addSubview(title)
        }else{
//             reusableview = UICollectionReusableView(frame: CGRect(x: 0, y: 60, width: self.collectionView.frame.width, height: 40))
            print("reusableview")
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(kind
                , withReuseIdentifier:"HeaderView" , forIndexPath: indexPath)
            let  title:UITableViewCell = UITableViewCell(frame: reusableview.frame)
       
            title.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            title.textLabel?.text = "推荐歌单"
           // title.backgroundColor = UIColor.redColor()
            reusableview.addSubview(title)
        }
        reusableview.backgroundColor = UIColor(patternImage:UIImage(named: "blue")!)
        reusableview.center.x = -reusableview.frame.width / 2
        
        UIView.animateWithDuration(1) { () -> Void in
            reusableview.center.x += self.collectionView.frame.width
        }
        return reusableview
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            //可选择2、3、4、5、6、7、8
            return self.count
    }
    
    // 获取单元格
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
           
            // storyboard里设计的单元格
            let identify:String = "ViewCell"
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! CollectionCell
            cell.imageView.image = UIImage(named: "blue")
            let str = courses[indexPath.item]["name"]! as NSString
            let contrainsts = CGSizeMake(cell.frame.width, 40)
            
            let size =  str.textSizeWithFont(UIFont(name:"Arial" , size: 14)!, constrainedToSize: contrainsts)
            
            cell.label.text = str as String
            cell.label.frame = CGRect(x:0,y: cell.frame.height - 35, width: size.width, height: size.height)
            
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
                cell.center.x += cell.frame.width + CGFloat(CGFloat(indexPath.row % (self.count / 2)) * self.view.frame.width / CGFloat(self.count / 2)) + 5
                //cell.center.y -= cell.frame.height * CGFloat(indexPath.row / (self.count / 2)) + self.view.frame.height - cell.frame.height
                print(indexPath.row)
            }
                        return cell
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
