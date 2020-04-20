//
//  AccountInputTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/12.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AccountInputTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
