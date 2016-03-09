
//
//  ExtensionScrollView.swift
//  Originality
//
//  Created by suze on 16/1/18.
//  Copyright © 2016年 suze. All rights reserved.
//

import Foundation


extension UIScrollView {
    func addHeaderWithCallback( callback:(() -> Void)!){
        let header:RefreshHeaderView = RefreshHeaderView.footer()
         header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(RefreshViewHeight))
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.addState(RefreshState.Normal)
    }
    func nowRefreshWithCallback( callback:(() -> Void)!){
        let header:RefreshHeaderView = RefreshHeaderView.refreshNow()
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(RefreshViewHeight))
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.State = RefreshState.Refreshing
        header.addState(RefreshState.Refreshing)
    }
    func removeHeader()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshHeaderView{
                view.removeFromSuperview()
            }
        }
    }
    
    
    func headerBeginRefreshing()
    {
        
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.beginRefreshing()
            }
        }
        
    }
    
  
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.endRefreshing()
            }
        }
        
    }
    
    func setHeaderHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    func isHeaderHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    func addFooterWithCallback( callback:(() -> Void)!){
        let footer:RefreshFooterView = RefreshFooterView.footer()
        
        self.addSubview(footer)
        
        footer.beginRefreshingCallback = callback
        
        footer.addState(RefreshState.Normal)
    }
    
    
    func removeFooter()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshFooterView{
                view.removeFromSuperview()
            }
        }
    }
    
    func footerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.beginRefreshing()
            }
        }
        
    }
    
    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.endRefreshing()
            }
        }
        
    }
    
    func setFooterHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    func isFooterHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    
    
    
}