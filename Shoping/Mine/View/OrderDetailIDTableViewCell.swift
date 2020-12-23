//
//  OrderDetailIDTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class OrderDetailIDTableViewCell: UITableViewCell {
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var fname: UILabel!
    @IBOutlet weak var sname: UILabel!
    
    @IBOutlet weak var heigh: NSLayoutConstraint!
    @IBOutlet weak var copyB: UIButton!
    @IBOutlet weak var confim: UILabel!
    @IBOutlet weak var shiiping: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
