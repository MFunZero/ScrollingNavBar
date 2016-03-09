//
//  CustomTableViewCell.swift
//  Originality
//
//  Created by suze on 16/2/6.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var picture:UIImageView = UIImageView()
    var titleLabel:UILabel = UILabel()
    var detailLabel:UILabel = UILabel()
    var timeLabel:UILabel = UILabel()
    
    var fileName:String?{
        didSet {
            let home = NSHomeDirectory() as NSString
            let path = home.stringByAppendingPathComponent("Library/Caches/DownloadFile") as NSString
            let imagePath = path.stringByAppendingPathComponent(fileName!)
            let isExits:Bool = NSFileManager.defaultManager().fileExistsAtPath(imagePath)
            let image = UIImage(contentsOfFile: imagePath)
            if isExits && image != nil{
                print("111111")
                self.picture.image = image
            }
            else {
            BmobProFile.getFileAcessUrlWithFileName(fileName) { (file, error) -> Void in
                if error != nil {
                    print("error:\(error)")
                }else{
                    let  url = NSURL(string: file.url)
                    let data = NSData(contentsOfURL: url!)
                    if data != nil {
                        self.picture.clipsToBounds = true
                        self.picture.layer.cornerRadius = self.picture.frame.width / 2
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
        picture.frame = CGRect(x: 25, y: 10, width: self.frame.height - 20, height: self.frame.height - 20)
        self.addSubview(picture)
        
        titleLabel.frame =  CGRect(x: picture.frame.origin.x + picture.frame.width + 15, y: 10, width: self.frame.width - picture.frame.width - 40 - 80, height: self.frame.height / 2 - 5)
        self.addSubview(titleLabel)
        
        detailLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: self.frame.height / 2 , width: self.frame.width - picture.frame.width - 30, height: self.frame.height / 2 - 5)
        self.addSubview(detailLabel)
        
        detailLabel.font = smallFont
        
        timeLabel.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.width, y: 5, width: 80, height: titleLabel.frame.height)
        self.addSubview(timeLabel)
        
        timeLabel.textAlignment = .Center
        timeLabel.font = nomalFont
        
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
