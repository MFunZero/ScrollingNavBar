//
//  PersonTableViewCell.swift
//  Originality
//
//  Created by suze on 16/2/9.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    var picture:UIImageView = UIImageView()
    var titleLabel:UILabel = UILabel()
  
    
    var pictureName:String?{
        didSet {
            let home = NSHomeDirectory() as NSString
            let path = home.stringByAppendingPathComponent("Library/Caches/DownloadFile") as NSString
            let imagePath = path.stringByAppendingPathComponent(pictureName!)
            let isExits:Bool = NSFileManager.defaultManager().fileExistsAtPath(imagePath)
            let image = UIImage(contentsOfFile: imagePath)
            if isExits && image != nil{
                print("111111")
                self.picture.image = image
            }
            else {
                BmobProFile.getFileAcessUrlWithFileName(pictureName) { (file, error) -> Void in
                    if error != nil {
                        print("error:\(error)")
                    }else{
                        let  url = NSURL(string: file.url)
                        let data = NSData(contentsOfURL: url!)
                        if data != nil {
                            
                            self.picture.image = UIImage(data: data!)
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect)
    {
        picture.frame = CGRect(x: 25, y: 5, width: self.frame.height - 10, height: self.frame.height - 10)
        self.addSubview(picture)
        
        titleLabel.frame =  CGRect(x: picture.frame.origin.x + picture.frame.width + 15, y: 10, width: self.frame.width - picture.frame.width - 35, height: self.frame.height - 20)
        self.addSubview(titleLabel)
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
