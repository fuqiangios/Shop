//
//  BaclFinshTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BaclFinshTableViewCell: UITableViewCell {
    @IBOutlet weak var orderId: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
