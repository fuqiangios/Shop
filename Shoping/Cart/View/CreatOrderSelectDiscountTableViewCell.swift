//
//  CreatOrderSelectDiscountTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/23.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSelectDiscountTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var info: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
