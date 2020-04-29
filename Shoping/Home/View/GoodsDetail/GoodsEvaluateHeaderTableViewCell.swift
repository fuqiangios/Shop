//
//  GoodsEvaluateHeaderTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/8.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsEvaluateHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var getMoreBtn: UIButton!
    @IBOutlet weak var lv: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
