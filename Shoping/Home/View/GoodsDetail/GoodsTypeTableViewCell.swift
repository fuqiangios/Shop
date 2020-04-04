//
//  GoodsTypeTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/8.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var typeName: UILabel!
    
    @IBOutlet weak var numType: UILabel!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
