//
//  SettingTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet weak var infoRight: NSLayoutConstraint!
    @IBOutlet weak var imgRight: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var info: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
