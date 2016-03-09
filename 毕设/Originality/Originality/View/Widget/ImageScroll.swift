//
//  File.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import Foundation
class ImageScroll: UIView ,UIScrollViewDelegate{

private var scrollView:UIScrollView!
private var pageControll:UIPageControl!
//图片名称数组
var imagesName:NSArray!
//设定timer
var timer:NSTimer!
//设定图片轮播时间间隔，可自行设定时间长度
var time:NSTimeInterval!
func addImages(){
    // print("this a page of PageControlls\(self.frame)")
    self.scrollView =  UIScrollView(frame:  CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
    
    

    self.pageControll = UIPageControl(frame: CGRect(x: screenWidth / 2.0 - 5.0, y: self.bounds.height - 20.0, width: 30.0, height: 15.0))
    self.pageControll.numberOfPages = imagesName.count
    
    self.pageControll.currentPageIndicatorTintColor = UIColor(red:0/255.0, green:179/255.0,blue:138/255.0,alpha: 1)
    self.pageControll.tintColor = UIColor.whiteColor()
    
    
    
    let imageW:CGFloat = self.frame.width
    let imageH:CGFloat = self.frame.height
    let totalCount:NSInteger = imagesName.count;
   
    for index in 0..<totalCount{
        let imageView:UIImageView = UIImageView()
        let imageX:CGFloat = CGFloat(index) * imageW
        imageView.frame = CGRectMake(imageX, 0, imageW,
            imageH)
        
        // print("imageviewFrame:\(imageView.frame)")
        imageView.image = UIImage(named:imagesName[index] as! String )
        // print("H:\(imageH),ImH:\(imageView.image?.size)")
        self.scrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
        self.scrollView.addSubview(imageView)
        //把图片加入到ScrollView中去，实现轮播的效果；
    }
    
    let contentW:CGFloat = imageW * CGFloat(totalCount)
    self.scrollView.contentSize = CGSizeMake(contentW, 0)
    self.scrollView.pagingEnabled = true
    self.scrollView.delegate = self
    self.addSubview(scrollView)
    self.addSubview(pageControll)
    
    
    self.addTimer()
}
func nextImage(){
    var page:Int = self.pageControll.currentPage;
    if(page == imagesName.count-1){
        page = 0;
    }else{
        ++page;
    }
    let x:CGFloat = CGFloat(page) * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}
func scrollViewDidScroll(scrollView: UIScrollView) {
    let scrollviewW:CGFloat = scrollView.frame.size.width;
    let x:CGFloat = scrollView.contentOffset.x;
    let page:Int = (Int)((x ) / scrollviewW);
    
  
    self.pageControll.currentPage = page;
}
func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    removeTimer()
}
func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    self.addTimer()
}
func addTimer(){
    var timeDefalut:NSTimeInterval
    if time == nil {
        timeDefalut = 3
    }else {
        timeDefalut = time
    }
    // print("time:\(timeDefalut)")
    self.timer = NSTimer.scheduledTimerWithTimeInterval(timeDefalut, target: self, selector: "nextImage", userInfo: nil, repeats: true)
    NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
}
func removeTimer(){
    self.timer.invalidate();
}
}
