//
//  GoodsAddressTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/7.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var express: UILabel!
    @IBOutlet weak var sale: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
