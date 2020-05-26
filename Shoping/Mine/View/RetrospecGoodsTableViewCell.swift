//
//  RetrospecGoodsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/24.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RetrospecGoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var sccj: UILabel!

    @IBOutlet weak var mgjsr: UILabel!
    @IBOutlet weak var gmsj: UILabel!
    @IBOutlet weak var gmdd: UILabel!
    @IBOutlet weak var scfzr: UILabel!
    @IBOutlet weak var scrq: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
