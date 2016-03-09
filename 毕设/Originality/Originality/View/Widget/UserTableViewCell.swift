//
//  UserTableViewCell.swift
//  Originality
//
//  Created by suze on 16/2/9.
//  Copyright © 2016年 suze. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    var avatarView:UIImageView = UIImageView()
    var nameLabel:UILabel = UILabel()
    
    
    var avatar:String?{
        
        didSet {
            
        }
    }
    
    override func drawRect(rect: CGRect) {
         avatarView.frame = CGRect(x: 20, y: self.frame.height / 2 - 30, width: 60, height: 60)
        
        self.addSubview(avatarView)
        
        nameLabel.frame = CGRect(x: avatarView.frame.origin.x + avatarView.frame.width + 15, y: avatarView.frame.origin.y + avatarView.frame.height/2 - 15, width: self.frame.width - avatarView.frame.width - 35, height: 30)
        self.addSubview(nameLabel)
        
        
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
