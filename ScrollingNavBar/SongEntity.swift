//
//  Song.swift
//  ScrollingNavBar
//
//  Created by suze on 15/10/18.
//  Copyright © 2015年 suze. All rights reserved.
//

import Foundation
class Song : NSObject{
    var title:String?
    var singer:String?
    var date:NSDate?
    var content:String?
    var mv:String?
    override init() {
        
    }
    required init(coder aDecoder:NSCoder) {
        
        super.init()
        
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.singer  = aDecoder.decodeObjectForKey("singer") as? String
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate
        self.content = aDecoder.decodeObjectForKey("content") as? String
        self.mv = aDecoder.decodeObjectForKey("mv") as? String
    }
    func encodeWithCoder(adecoder:NSCoder){
        adecoder.encodeObject(self.title, forKey: "title")
        adecoder.encodeObject(self.singer, forKey: "singer")
        adecoder.encodeObject(self.date, forKey: "date")
        adecoder.encodeObject(self.content, forKey: "content")
        adecoder.encodeObject(self.mv, forKey: "mv")
    }
    
    override var description:String{
        get {
            return NSString(format: "title:%@,singer:%@,date:%@,content:%@,mv:%@", self.title!,self.singer!,self.date!,self.content!,self.mv!)
                as String
        }
    }
    
}