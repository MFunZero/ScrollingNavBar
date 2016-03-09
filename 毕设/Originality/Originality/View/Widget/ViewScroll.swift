//
//  ViewScroll.swift
//  Originality
//
//  Created by suze on 16/1/14.
//  Copyright © 2016年 suze. All rights reserved.
//

import Foundation
class ViewScroll: UIView ,UIScrollViewDelegate{
    
    private var scrollView:UIScrollView!
    
    var imageData:[NSData]!
    var imageTitle:[String]!
    //图片名称数组
    var imagesName:NSArray!
    var imagesTitle:NSArray!
    //设定timer
    var timer:NSTimer!
    //设定图片轮播时间间隔，可自行设定时间长度
    var time:NSTimeInterval!
    func addImages(){
        // print("this a page of PageControlls\(self.frame)")
        self.scrollView =  UIScrollView(frame:  CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        
       
        
        let imageW:CGFloat = ViewScrollWidth
        let imageH:CGFloat = self.frame.height
        let totalCount:NSInteger = imagesName.count;
        //轮播的图片数量；
        for index in 0..<totalCount{
            let imageView:UIImageView = UIImageView()
            let textLable:UILabel = UILabel()
            let imageX:CGFloat = CGFloat(index) * CGFloat(imageW) + CGFloat(index ) * 10.0 + 10
            imageView.frame = CGRectMake(imageX, 10, imageW,
                imageH - 40)
            textLable.frame = CGRectMake(imageX, imageView.frame.height + 15, imageW,
                20)
            textLable.font = UIFont(name: "Arial", size: 12)
            if imageData != nil {
            
            }else {
            imageView.image = UIImage(named:imagesName[index] as! String )
            textLable.text = imageTitle[index]
            }
            self.scrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.scrollView.addSubview(imageView)
            self.scrollView.addSubview(textLable)
        }
        
        let contentW:CGFloat = (imageW + 10.0) * CGFloat(totalCount) + 10
        self.scrollView.contentSize = CGSizeMake(contentW, 0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.addSubview(scrollView)
        
        
    }
 
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
         print("pagescrolled")
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
     
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
    }
}