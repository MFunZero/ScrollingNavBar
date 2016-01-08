//
//  detailCellTableViewCell.swift
//  ScrollingNavBar
//
//  Created by suze on 15/10/19.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class detailCellTableViewCell: UITableViewCell {


    
    @IBOutlet weak var downloading: UIImageView!
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var Song: UILabel!
    @IBOutlet weak var Shoucang: UIImageView!
    @IBOutlet weak var eye: UIImageView!
    public var statusShouchang:Bool = false
    override  func awakeFromNib() {
        super.awakeFromNib()

        Shoucang.userInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        Shoucang .addGestureRecognizer(singleTap)
    }
    func imageViewTouch(){
        print("shoucang")
        if !statusShouchang {
          Shoucang.image = UIImage(named: "shoucang1")
            self.statusShouchang = !statusShouchang
            self.Collection()
        }else{
            Shoucang.image = UIImage(named: "shoucang")
            self.statusShouchang = !statusShouchang
            self.CancelCollection()
        }
        
    }
    func CancelCollection(){
        
        let path = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Collections.plist")
        let da = NSMutableDictionary(contentsOfFile: path)
   
        let tex = Song.text!
        print(tex)
        da?.setValue(nil, forKey:tex)
        
        print("\(NSHomeDirectory())")
        
        da?.writeToFile(path, atomically: true)
    }
    func Collection(){
        let path = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Collections.plist")
        let da = NSMutableDictionary(contentsOfFile: path)
        
        
        let text = Song.text!
        print(text)
        let Collections = true
        da?.setValue(Collections,forKey: text)
        
        da?.writeToFile(path, atomically: true)
        

    
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
