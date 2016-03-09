//
//  GetImageData.swift
//  Originality
//
//  Created by suze on 16/1/13.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

protocol getDataDelegate {
    func operation(data:NSMutableData)
}
class GetImageData: NSOperation {

    var delegate:getDataDelegate?
    var myData:NSMutableData?
    override func main() {
        
        super.main()
      
        if self.myData != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let myDelegate = self.delegate {
                    print("delegate")
                    myDelegate.operation(self.myData!)
                }
            })
        }
        else {
            print("myData is nil")
        }
        
        
    }
   
  

  
  
}
