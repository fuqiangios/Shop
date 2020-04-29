//
//  AccountSubmitTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/26.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AccountSubmitTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
