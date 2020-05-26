//
//  LogisticsTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/22.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class LogisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bottom: UIImageView!
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var dian: UIImageView!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
