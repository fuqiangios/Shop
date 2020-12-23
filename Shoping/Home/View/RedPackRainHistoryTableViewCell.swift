//
//  RedPackRainHistoryTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/11.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RedPackRainHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var num: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
