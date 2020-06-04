//
//  UserVipDetailTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class UserVipDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var nm: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var yongjin: UILabel!
    @IBOutlet weak var redPackge: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
