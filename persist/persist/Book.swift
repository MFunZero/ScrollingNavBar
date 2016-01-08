//
//  Book.swift
//  persist
//
//  Created by suze on 15/11/13.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class Book: NSObject {
     var name:String?
     var writer:String?
     var writeDate:NSDate?
    override init(){
        
    }
     required  init(coder aDecoder:NSCoder) {
        super.init()
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.writer = aDecoder.decodeObjectForKey("writer") as? String
        self.writeDate = aDecoder.decodeObjectForKey("writeDate") as? NSDate
    }
    
    func encodeWithCoder(aDecoder:NSCoder){
        aDecoder.encodeObject(self.name, forKey: "name")
        aDecoder.encodeObject(self.writer, forKey: "writer")
        aDecoder.encodeObject(self.writeDate, forKey: "wroteDate")
    }
}
