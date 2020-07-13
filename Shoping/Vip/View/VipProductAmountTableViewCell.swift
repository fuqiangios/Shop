//
//  VipProductAmountTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/7/1.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class VipProductAmountTableViewCell: UITableViewCell {
    @IBOutlet weak var allAmount: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lastAmount: UILabel!
    @IBOutlet weak var jiAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1).cgColor
        bgView.layer.cornerRadius = 3
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
