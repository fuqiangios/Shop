//
//  GoodsPopUpTransateTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsPopUpTransateTableViewCell: UITableViewCell {

    @IBOutlet weak var bbtn: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var info: UILabel!
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
