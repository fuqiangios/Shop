//
//  AddressAddInfoTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AddressAddInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var inputField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
