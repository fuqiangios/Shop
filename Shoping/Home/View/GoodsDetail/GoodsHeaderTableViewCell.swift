//
//  GoodsHeaderTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/7.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var price_sort: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zan: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
