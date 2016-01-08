//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by suze on 15/12/5.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    var label:UILabel = UILabel()
    var imageView:UIImageView = UIImageView()
    
    override func drawRect(rect: CGRect) {
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 35)
        label.textAlignment = NSTextAlignment.Left
        label.font = UIFont(name:"Arial" , size: 14)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
       
//        label.frame = CGRect(x:0,y: self.frame.height - 35, width: self.frame.width, height: 35)
        
        
//        let str = label.text as! NSString
//        let contrainsts = CGSizeMake(label.frame.width, 40)
//        
//        let size =  str.textSizeWithFont(UIFont(name:"Arial" , size: 14)!, constrainedToSize: contrainsts)
//        
//        label.text = str as String
//        label.frame = CGRect(x:0,y: self.frame.height - 35, width: size.width, height: size.height)
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
    }
    
}

