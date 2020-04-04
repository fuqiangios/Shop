//
//  MineOrderTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MineOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var payBtn: UIButton!

    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var evaluateBtn: UIButton!
    @IBOutlet weak var receivingBtn: UIButton!
    @IBOutlet weak var deliverBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
