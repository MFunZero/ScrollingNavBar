//
//  Define.swift
//  Originality
//
//  Created by suze on 16/1/14.
//  Copyright © 2016年 suze. All rights reserved.
//

import Foundation
import UIKit

var screenHeight = UIScreen.mainScreen().bounds.height
var screenWidth = UIScreen.mainScreen().bounds.width

var labelHeight:CGFloat = 40


let ViewScrollWidth:CGFloat = 120


let PageDataCount:Int = 10







//

let InitialNumber:Int = 20

//let userId:String = "VL4u777D"

//let currentUser = BmobUser.getCurrentUser()
let currentUser = "7X51IIIZ"


let folder:String = NSHomeDirectory() + "/Library/Caches/DownloadFile/"
//设置预加载状态
var preLoading:Bool = true

//corlorConstant
var maincolor:UIColor = UIColor(red: 0, green: 179/255, blue: 138/255, alpha: 1)

var userNameColor:UIColor = UIColor(red:111/255.0, green:156/255.0,blue:226/255.0,alpha: 1)
var contentColor:UIColor = UIColor.whiteColor()
var bgColor:UIColor = UIColor(red:234/255.0, green:235/255.0,blue:236/255.0,alpha: 1)

var titleCorlor:UIColor = UIColor(red:80/255.0, green:80/255.0,blue:80/255.0,alpha: 1)
var detailCountColor:UIColor = UIColor(red:191/255.0, green:207/255.0,blue:213/255.0,alpha: 1)
var splitViewColor:UIColor = UIColor(red:191/255.0, green:207/255.0,blue:213/255.0,alpha: 1)

var specialNameCorlor:UIColor = UIColor(red:100/255.0, green:100/255.0,blue:100/255.0,alpha: 1)

var nomalFont:UIFont = UIFont(name:"Arial" , size: 13)!

var smallFont:UIFont = UIFont(name:"Arial" , size: 11)!

var bigFont:UIFont = UIFont(name:"Arial" , size: 15)!



//设置点赞视图中用户头像间间距
var distance:CGFloat = (screenWidth - 40 * 7)/5


//设置当前时间以及时间格式
let date = NSDate()
let format = NSDateFormatter()


//添加图片背景
var img_login:String = "img_login"
var camer:String = "wandershopbottonbutton_publish"
var photo:String = "tabbar_compose_photo"
var cancel:String = "cancel@3x.png"
var defaultImage:String = "defaultimage"