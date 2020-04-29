//
//  MessageTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/26.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
