//
//  SinglePictureInfo.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class SinglePictureInfo: NSObject {

    var objectId:String!
    var tagId:Int!
    var url:String!
    var userAvator:String!
    var userId:String!
    var userName:String!
    var specialId:String!
    var title:String!
    var specialName:String!
    var comment:Array<NSDictionary>!
    var collection:Array<NSDictionary>!
    var upvote:Array<NSDictionary>!
    var commentCount:Int!
    var collectionCount:Int!
    var upvoteCount:Int!
    
    
    
    override init() {
       
       //
        //[{"userId":"bPVX555A","commentId":"GTrU999C","replyto":"xFWO111A","content":"超赞，心水!"},{"userId":"xFWO111A","commentId":"DFktIIIS","replyto":"VL4u777D","content":"赞一个"}]
        
        //[{"userId":"bPVX555A","specialId":"bPVX555A","collectionId":"7BvcFFFY"},{"userId":"7X51IIIZ","specialId":"z4TvDDDI","collectionId":"kNTBFFFR"}]
        
    }
    
    override var description: String {
       
                 return "SinglePicture:\(objectId),\(tagId),\(url),\(userAvator),\(userId),\(userName),\(title),\(specialName),\(commentCount),\(collectionCount),\(upvoteCount)"
           }
   
}
