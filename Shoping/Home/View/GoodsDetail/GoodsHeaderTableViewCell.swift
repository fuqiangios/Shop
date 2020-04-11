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
    
    @IBOutlet weak var hao: UILabel!
    @IBOutlet weak var xiao: UILabel!
    @IBOutlet weak var shippingContent: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zan: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        shippingContent.layer.borderColor = shippingContent.textColor.cgColor
        shippingContent.layer.borderWidth = 1
        shippingContent.layer.cornerRadius = 9
        shippingContent.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
