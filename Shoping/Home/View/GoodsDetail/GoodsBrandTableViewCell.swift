//
//  GoodsBrandTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/8.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsBrandTableViewCell: UITableViewCell {
    @IBOutlet weak var info: UILabel!
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
