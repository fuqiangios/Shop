//
//  GoodsTipsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/4.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsTipsTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var tips: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
