//
//  LogOutTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
