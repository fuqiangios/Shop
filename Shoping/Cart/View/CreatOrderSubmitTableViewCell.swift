//
//  CreatOrderSubmitTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/3/5.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSubmitTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.isUserInteractionEnabled = false
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
