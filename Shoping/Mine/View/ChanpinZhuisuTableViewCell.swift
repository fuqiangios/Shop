//
//  ChanpinZhuisuTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/7/2.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ChanpinZhuisuTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var num: UILabel!
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
