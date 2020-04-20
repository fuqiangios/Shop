//
//  MineImgTableViewCell.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MineImgTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
