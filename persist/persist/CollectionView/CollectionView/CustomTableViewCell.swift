//
//  CustomTableViewCell.swift
//  CollectionView
//
//  Created by suze on 15/12/10.
//  Copyright © 2015年 suze. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var detailLabel:UILabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        detailLabel.frame = CGRect(x: 100, y: 0, width: self.frame.width / 3, height: 35)
        detailTextLabel
    self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
